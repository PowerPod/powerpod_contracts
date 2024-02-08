// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";


contract TokenDistribution is Initializable, OwnableUpgradeable, UUPSUpgradeable {
    uint256 public constant INITIAL_PRODUCTION = 45 * 10**6 * 10**18; // 45 million tokens, assuming 18 decimals
    uint256 public productionRate;
    uint256 public lastHalvingTime;
    uint256 public constant HALVING_PERIOD = 4 * 365 days;

    // Mapping to track user investments
    mapping(address => uint256) public investments;

    // Event for investment
    event Invested(address investor, uint256 amount);

    constructor() ERC20("PPDToken", "PPD") {
        productionRate = INITIAL_PRODUCTION;
        lastHalvingTime = block.timestamp;
        // Initial mint to the contract itself or a specific address
        _mint(address(this), INITIAL_PRODUCTION);
    }

    // Call this function to halve the production rate, can be automated or called manually
    function halveProduction() public onlyOwner {
        require(block.timestamp >= lastHalvingTime + HALVING_PERIOD, "Halving period not reached");
        productionRate /= 2;
        lastHalvingTime = block.timestamp;
    }

    // Function to invest PT tokens (this requires more implementation details)
    function investPT(uint256 amount) public {
        // Logic to accept PT tokens and track investments
        investments[msg.sender] += amount;
        emit Invested(msg.sender, amount);
    }

    // Function to distribute PPD tokens (this is a simplified placeholder)
    function distributeTokens() public {
        // Logic to distribute tokens based on investments every 12 hours
        // If no investments, burn the tokens instead
    }

    // Include upgradeability functions and logic here
    // This would typically involve a separate contract for the proxy
}

// Note: Actual upgradeability setup would involve deploying a proxy contract
// and managing upgrades through it, ensuring state and logic are correctly handled.
