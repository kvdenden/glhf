// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.6;

// @author Modified from Nouns (https://github.com/nounsDAO/nouns-monorepo/blob/master/packages/nouns-contracts/contracts/interfaces/IWETH.sol)
interface IWETH {
    function deposit() external payable;

    function withdraw(uint256 wad) external;

    function transfer(address to, uint256 value) external returns (bool);
}
