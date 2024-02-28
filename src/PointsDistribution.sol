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
    PTPoints public points;
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    event Minted(address to, uint256 amount);
    event BurnedAllPTPoints();

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize(address _PTPointsAddress) public initializer {
        __Ownable_init(msg.sender);
        __AccessControl_init();
        __UUPSUpgradeable_init();
        __ReentrancyGuard_init();

        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        points = PTPoints(_PTPointsAddress);
    }

    function mint(address to, uint256 amount) public onlyRole(MINTER_ROLE) {
        points.transfer(to, amount);

        emit Minted(to, amount);
    }

    function burnAllPTPoints() public onlyOwner {
        uint256 balance = points.balanceOf(address(this));
        points.burn(balance);

        emit BurnedAllPTPoints();
    }

    function _authorizeUpgrade(
        address newImplementation
    ) internal override onlyOwner {}
    
}
