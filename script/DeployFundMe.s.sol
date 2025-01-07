// SPDX License Identifier: MIT

pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployFundMe is Script {
    function run() external returns (FundMe) {
        HelperConfig helperConfig = new HelperConfig();
        (address ethUsdPriceFeed) = helperConfig.activeNetworkConfig();

        vm.startBroadcast(); //start using the gas here - Real transaction
        // Mock contract
        FundMe fundMe = new FundMe(ethUsdPriceFeed);
        vm.stopBroadcast();
        return fundMe;
    }

    function printStorageData(address contractAddress) public view {
        for (uint256 i = 0; i < 10; i++) {
            bytes32 value = vm.load(contractAddress, bytes32(i));
            console.log("Value at location", i, ":");
            console.logBytes32(value);
        }
    }
}
