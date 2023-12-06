// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

import {ITokenRenderer} from "./interfaces/ITokenRenderer.sol";

contract TokenRenderer is Ownable, ITokenRenderer {
    using Strings for uint256;
    string private _baseURI;

    constructor(string memory baseURI) Ownable(msg.sender) {
        _baseURI = baseURI;
    }

    function setBaseURI(string memory newBaseURI) external onlyOwner {
        _baseURI = newBaseURI;
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        return bytes(_baseURI).length > 0 ? string(abi.encodePacked(_baseURI, tokenId.toString())) : "";
    }
}
