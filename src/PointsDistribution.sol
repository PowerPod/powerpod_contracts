// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/ReentrancyGuardUpgradeable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "./PTPoints.sol";

contract PointsDistribution is 
    Initializable, 
    OwnableUpgradeable, 
    AccessControlUpgradeable,
    UUPSUpgradeable, 
    ReentrancyGuardUpgradeable  
{
    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    IERC20 public PTPoints;
    function initialize(address _PTPointsAddress) public initializer {
        __Ownable_init(msg.sender);
        __AccessControl_init();
        __UUPSUpgradeable_init();
        __ReentrancyGuard_init();

        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        PTPoints = PTPoints(_PTPointsAddress);
    }

    function _authorizeUpgrade(
        address newImplementation
    ) internal override onlyOwner {}

    
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    function mint(address to, uint256 amount) public onlyRole(MINTER_ROLE) {
        PTPoints.transfer(to, reward);
    }

    function burnAllPTPoints() public onlyOwner {
        uint256 balance = token.balanceOf(address(this));
        token.burn(balance);
    }
    
}
