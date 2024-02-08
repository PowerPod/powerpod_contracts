// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";


contract TokenDistribution is Initializable, OwnableUpgradeable, UUPSUpgradeable {
    IERC20 public PPDToken;

    uint256 public constant INITIAL_PRODUCTION = 45 * 10**6 * 10**18;
    uint256 public productionRate;
    uint256 public lastHalvingTime;
    uint256 public constant HALVING_PERIOD = 4 * 365 days;

    mapping(address => uint256) public investments;

    event Invested(address investor, uint256 amount);

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize(address _PPDTokenAddress) public initializer {
        __Ownable_init(msg.sender);
        __UUPSUpgradeable_init();

        PPDToken = IERC20(_PPDTokenAddress);

        productionRate = INITIAL_PRODUCTION;
        lastHalvingTime = block.timestamp;
    }

    function halveProduction() public onlyOwner {
        require(block.timestamp >= lastHalvingTime + HALVING_PERIOD, "Halving period not reached");
        productionRate /= 2;
        lastHalvingTime = block.timestamp;
    }

    function investPT(uint256 amount) public {
        investments[msg.sender] += amount;
        emit Invested(msg.sender, amount);
    }

    function distributeTokens() public {
        // Logic to distribute tokens based on investments every 12 hours
        // If no investments, burn the tokens instead
    }

    function _authorizeUpgrade(
        address newImplementation
    ) internal override onlyOwner {}
}

