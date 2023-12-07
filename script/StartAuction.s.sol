// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {Script, console2} from "forge-std/Script.sol";

import {AuctionHouse} from "../src/AuctionHouse.sol";

contract StartAuctionScript is Script {
    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        AuctionHouse auctionHouse = AuctionHouse(vm.envAddress("AUCTIONHOUSE_CONTRACT_ADDRESS"));

        auctionHouse.unpause();

        vm.stopBroadcast();
    }
}
