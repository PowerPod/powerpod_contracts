// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../src/PTPoints.sol";
import "forge-std/Script.sol";

contract DeployPTPointsImplementation is Script {
    function run() external {
        vm.startBroadcast();

        PTPoints implementation = new PTPoints();

        vm.stopBroadcast();

        console.log("Token Implementation Address:", address(implementation));
    }
}
