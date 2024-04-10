// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts-upgradeable/utils/ReentrancyGuardUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import "./PTPoints.sol";

contract PaymentContract is
    Initializable,
    UUPSUpgradeable,
    OwnableUpgradeable,
    ReentrancyGuardUpgradeable
{
    IERC20 public usdt;
    PTPoints public points;

    struct PaymentInfo {
        address receiver;
        uint256 amount;
        uint256 withdrawableAfter;
    }

    mapping(uint256 => PaymentInfo) public payments;
    uint256 public totalFeesAccumulated;

    function initialize(
        address _usdtAddress,
        address _PTPointsAddress
    ) public initializer {
        __Ownable_init(msg.sender);
        __UUPSUpgradeable_init();
        __ReentrancyGuard_init();

        usdt = IERC20(_usdtAddress);
        points = PTPoints(_PTPointsAddress);
    }

    event PaymentReceived(
        address indexed sender,
        address indexed receiver,
        uint256 indexed billId,
        uint256 amount,
        uint256 fee,
        uint256 pt
    );

    event PaymentPaid(
        address indexed receiver,
        uint256 indexed billId,
        uint256 amount
    );

    function payBill(
        uint256 billId,
        uint256 amount,
        address receiver
    ) external {
        require(payments[billId].receiver == address(0), "Bill already paid");
        require(amount > 0, "Amount must be greater than 0");

        uint256 fee = (amount * 5) / 100;
        uint256 amountAfterFee = amount - fee;
        // each 1 USD cent gives 50 pt to the payer and 50 points to the receiver
        uint256 pt = (amount / 1e4) * 50 * 1e18;

        payments[billId] = PaymentInfo({
            receiver: receiver,
            amount: amountAfterFee,
            withdrawableAfter: block.timestamp + 12 hours
        });

        totalFeesAccumulated += fee;

        usdt.transferFrom(msg.sender, address(this), amount);
        points.transfer(msg.sender, pt);
        points.transfer(receiver, pt);

        emit PaymentReceived(msg.sender, receiver, billId, amount, fee, pt);
    }

    function withdraw(uint256 billId) external nonReentrant {
        require(payments[billId].receiver == msg.sender, "Not the receiver");
        require(
            block.timestamp >= payments[billId].withdrawableAfter,
            "Too early to withdraw"
        );

        uint256 amount = payments[billId].amount;
        require(amount > 0, "No funds to withdraw");

        payments[billId].amount = 0;
        usdt.transfer(msg.sender, amount);

        emit PaymentPaid(msg.sender, billId, amount);
    }

    function withdrawFees() external onlyOwner {
        uint256 amount = totalFeesAccumulated;
        require(amount > 0, "No fees to withdraw");

        totalFeesAccumulated = 0;
        usdt.transfer(msg.sender, amount);
    }

    function _authorizeUpgrade(
        address newImplementation
    ) internal override onlyOwner {}
}
