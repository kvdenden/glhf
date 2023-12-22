// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

interface ITokenUpdateHandler {
    /**
     * Handles token transfer events from a ERC721 contract
     */
    function handleUpdate(address tokenContract, address to, uint256 tokenId, address auth) external;
}
