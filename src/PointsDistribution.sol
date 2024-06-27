// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
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

    mapping(uint256 => bool) public minted;

    event Minted(uint256 indexed id, address indexed to, uint256 amount);
    event BurnedAllPTPoints();

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize(address _ptPointsAddress) public initializer {
        __Ownable_init();
        __AccessControl_init();
        __UUPSUpgradeable_init();
        __ReentrancyGuard_init();

        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        points = PTPoints(_ptPointsAddress);
    }

    function mint(
        uint256 id,
        address to,
        uint256 amount
    ) public onlyRole(MINTER_ROLE) {
        require(!minted[id], "PTPoints: already minted");
        minted[id] = true;
        points.transfer(to, amount);

        emit Minted(id, to, amount);
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
