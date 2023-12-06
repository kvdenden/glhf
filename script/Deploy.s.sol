// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {Script, console2} from "forge-std/Script.sol";

import {GLHF} from "../src/GLHF.sol";
import {TokenRenderer} from "../src/TokenRenderer.sol";
import {SignatureMinter} from "../src/SignatureMinter.sol";

contract DeployScript is Script {
    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        GLHF glhf = new GLHF();
        console2.log("GLHF deployed at address: ", address(glhf));

        SignatureMinter minter = new SignatureMinter(glhf);
        console2.log("SignatureMinter deployed at address: ", address(minter));

        string memory baseURI = vm.envString("BASE_URI");
        TokenRenderer renderer = new TokenRenderer(baseURI);
        console2.log("TokenRenderer deployed at address: ", address(renderer));

        glhf.setRenderer(renderer);

        vm.stopBroadcast();
    }
}
