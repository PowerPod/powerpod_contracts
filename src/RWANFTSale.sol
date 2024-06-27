// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract RWANFTSale is
    Initializable,
    OwnableUpgradeable,
    UUPSUpgradeable,
    ReentrancyGuardUpgradeable
{
    IERC721 public nft;
    IERC20 public usdc;

    uint256 public constant PRICE = 0.001 * 1e6; // USDC has 6 decimals
    uint256 public whitelistStartTime;
    uint256 public publicSaleStartTime;
    uint256 public publicSaleEndTime;

    uint256 public _nextTokenId;
    uint256 public maxSupply;

    mapping(address => bool) public whitelist;

    function initialize(
        address _nftAddress,
        address _usdcAddress,
        uint256 _whitelistStart,
        uint256 _publicStart,
        uint256 _publicEnd,
        uint256 _maxSupply
    ) public initializer {
        __Ownable_init();
        __UUPSUpgradeable_init();
        __ReentrancyGuard_init();

        nft = IERC721(_nftAddress);
        usdc = IERC20(_usdcAddress);
        whitelistStartTime = _whitelistStart;
        publicSaleStartTime = _publicStart;
        publicSaleEndTime = _publicEnd;

        maxSupply = _maxSupply;
    }

    function addToWhitelist(address _user) public onlyOwner {
        whitelist[_user] = true;
    }

    function removeFromWhitelist(address _user) public onlyOwner {
        whitelist[_user] = false;
    }

    function buyNFTs(uint256 num) external nonReentrant {
        require(block.timestamp >= whitelistStartTime, "Sale has not started");
        require(block.timestamp <= publicSaleEndTime, "Sale has ended");

        if (block.timestamp < publicSaleStartTime) {
            require(whitelist[msg.sender], "Not whitelisted");
        }

        require(_nextTokenId + num <= maxSupply, "Exceeds MAX_SUPPLY");

        uint256 totalCost = PRICE * num;
        require(
            usdc.transferFrom(msg.sender, address(this), totalCost),
            "Payment failed"
        );

        for (uint256 i = 0; i < num; i++) {
            _nextTokenId++;
            nft.transferFrom(address(this), msg.sender, _nextTokenId);
        }
    }

    function withdrawPayments() public onlyOwner {
        uint256 balance = usdc.balanceOf(address(this));
        require(usdc.transfer(msg.sender, balance), "Withdrawal failed");
    }

    function updateWhitelistStartTime(uint256 _newTime) public onlyOwner {
        whitelistStartTime = _newTime;
    }

    function updatePublicSaleStartTime(uint256 _newTime) public onlyOwner {
        publicSaleStartTime = _newTime;
    }

    function updatePublicSaleEndTime(uint256 _newTime) public onlyOwner {
        publicSaleEndTime = _newTime;
    }

    function _authorizeUpgrade(
        address newImplementation
    ) internal override onlyOwner {}
}
