// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";

interface IMintableERC721 is IERC721 {
    function mint(address to, uint256 quantity) external returns (uint256[] memory tokenIds);

    function totalSupply() external view returns (uint256);
}
