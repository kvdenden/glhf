// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {Script, console2} from "forge-std/Script.sol";

import {WETH9} from "../src/WETH9.sol";

import {GLHF} from "../src/GLHF.sol";
import {TokenRenderer} from "../src/TokenRenderer.sol";

import {SignatureMinter} from "../src/SignatureMinter.sol";
import {AuctionHouse} from "../src/AuctionHouse.sol";

contract DeployScript is Script {
    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        WETH9 weth = new WETH9();
        console2.log("WETH deployed at address: ", address(weth));

        GLHF glhf = new GLHF();
        console2.log("GLHF deployed at address: ", address(glhf));

        string memory baseURI = vm.envString("BASE_URI");
        TokenRenderer renderer = new TokenRenderer(baseURI);
        console2.log("TokenRenderer deployed at address: ", address(renderer));

        glhf.setRenderer(renderer);

        SignatureMinter minter = new SignatureMinter(glhf);
        console2.log("SignatureMinter deployed at address: ", address(minter));

        uint256 timeBuffer = vm.envUint("AUCTION_TIME_BUFFER");
        uint256 reservePrice = vm.envUint("AUCTION_RESERVE_PRICE");
        uint256 minBidIncrementPercentage = vm.envUint("AUCTION_MIN_BID_INCREMENT_PERCENTAGE");
        uint256 duration = vm.envUint("AUCTION_DURATION");

        AuctionHouse auctionHouse = new AuctionHouse(
            glhf,
            address(weth),
            timeBuffer,
            reservePrice,
            uint8(minBidIncrementPercentage),
            duration
        );
        console2.log("AuctionHouse deployed at address: ", address(auctionHouse));

        glhf.grantRole(glhf.MINTER_ROLE(), (address(minter)));
        glhf.grantRole(glhf.MINTER_ROLE(), (address(auctionHouse)));

        vm.stopBroadcast();
    }
}
