// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/ReentrancyGuardUpgradeable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "./PTPoints.sol";

contract TokenDistribution is 
    Initializable, 
    OwnableUpgradeable, 
    UUPSUpgradeable, 
    ReentrancyGuardUpgradeable 
{
    IERC20 public token;
    PTPoints public points;

    uint256 public constant INITIAL_PRODUCTION = 45 * 10**6 * 10**18;
    uint256 public constant HALVING_PERIOD = 4 * 365 days;
    uint32 public constant PERIOD_LENGTH_IN_SECONDS = 12 * 60 * 60;
    uint256 public lastHalvingTime;
    uint256 public startTime;

    uint256 public annualAllocation;
    uint256 public dailyAllocation;
    uint256 public periodAllocation;
    
    mapping(uint32 => mapping(address => uint256)) public investments;
    mapping(uint32 => uint256) public totalInvestedInPeriod;
    mapping(uint32 => mapping(address => bool)) public rewardClaimed;

    mapping(uint32 => bool) public periodBurned;

    event Invested(address investor, uint32 period, uint256 amount);
    event TokensClaimed(address investor, uint32 period, uint256 amount);

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    error OnlyEOA();

    modifier onlyEOA() {
        if (msg.sender != tx.origin) {
            revert OnlyEOA();
        }
        _;
    }

    function initialize(address _PPDTokenAddress, address _PTPointsAddress) public initializer {
        __Ownable_init(msg.sender);
        __UUPSUpgradeable_init();
        __ReentrancyGuard_init();

        token = IERC20(_PPDTokenAddress);
        points = PTPoints(_PTPointsAddress);

        annualAllocation = INITIAL_PRODUCTION * 125 / 1000;
        dailyAllocation = annualAllocation / 365;
        periodAllocation = dailyAllocation / 2;

        lastHalvingTime = block.timestamp;
        
        uint256 currentTimestamp = block.timestamp;
        uint256 secondsUntilNextHour = 3600 - (currentTimestamp % 3600);
        startTime = currentTimestamp + secondsUntilNextHour;
    }

    function getCurrentPeriod() public view returns (uint32) {
        require(block.timestamp >= startTime, "Distribution has not started yet");

        uint256 timeSinceLastHalving = block.timestamp - startTime;
        uint32 periodsSinceLastHalving = uint32(timeSinceLastHalving / PERIOD_LENGTH_IN_SECONDS);

        return periodsSinceLastHalving + 1;
    }

    function halveProduction() public {
        require(block.timestamp >= lastHalvingTime + HALVING_PERIOD, "Halving period not reached");
        
        annualAllocation = annualAllocation / 2;
        dailyAllocation = annualAllocation / 365;
        periodAllocation = dailyAllocation / 2;

        lastHalvingTime = block.timestamp;
    }

    function investPT(uint32 _period, uint256 _amount) public onlyEOA{
        require(_amount > 0, "Investment amount must be greater than 0");

        uint32 currentPeriod = getCurrentPeriod();
        require(_period == currentPeriod, "Invalid investment period");

        points.burnFrom(msg.sender, _amount);
        investments[_period][msg.sender] += _amount;

        emit Invested(msg.sender, _period, _amount);
    }

    function claimTokens(uint32 _period) public nonReentrant{
        require(!rewardClaimed[_period][msg.sender], "Reward already claimed");

        uint256 periodEndTime = startTime + (_period * PERIOD_LENGTH_IN_SECONDS);
        require(block.timestamp > periodEndTime, "Period has not ended yet");

        uint256 invested = investments[_period][msg.sender];
        require(invested > 0, "No investment in period");

        uint256 totalInvested = totalInvestedInPeriod[_period];
        uint256 reward = (periodAllocation * invested) / totalInvested;

        require(reward > 0, "No tokens to claim");
        rewardClaimed[_period][msg.sender] = true;

        token.transfer(msg.sender, reward);
        emit TokensClaimed(msg.sender, _period, reward);
    }

    function burnUninvestedPeriodTokens(uint32 _period) public {
        uint256 periodEndTime = startTime + (_period * PERIOD_LENGTH_IN_SECONDS);
        require(block.timestamp > periodEndTime, "Period has not ended yet");

        require(!periodBurned[_period], "Period already burned");

        uint256 totalInvested = totalInvestedInPeriod[_period];
        require(totalInvested == 0, "Period has investments");
        
        periodBurned[_period] = true;

        uint256 tokensToBurn = periodAllocation;
        token.transfer(address(0x0), tokensToBurn);
    }

    function _authorizeUpgrade(
        address newImplementation
    ) internal override onlyOwner {}
}

