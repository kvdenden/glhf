// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

interface IMintable {
    function mint(address to, uint256 quantity) external;

    function totalSupply() external view returns (uint256);
}
