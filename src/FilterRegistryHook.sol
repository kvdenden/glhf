// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {IOperatorFilterRegistry} from "operator-filter-registry/src/IOperatorFilterRegistry.sol";

import {ITokenUpdateHandler} from "./interfaces/ITokenUpdateHandler.sol";

contract FilterRegistryHook is ITokenUpdateHandler, Ownable {
    IOperatorFilterRegistry private _operatorFilterRegistry;

    error OperatorNotAllowed(address operator);

    constructor(address owner) Ownable(owner) {}

    function getOperatorFilterRegistry() external view returns (IOperatorFilterRegistry) {
        return _operatorFilterRegistry;
    }

    function setOperatorFilterRegistry(IOperatorFilterRegistry newRegistry) external onlyOwner {
        _operatorFilterRegistry = newRegistry;
    }

    function handleUpdate(
        address tokenContract,
        address /* to */,
        uint256 /* tokenId */,
        address auth
    ) external view override {
        if (
            address(_operatorFilterRegistry).code.length > 0 &&
            !_operatorFilterRegistry.isOperatorAllowed(tokenContract, auth)
        ) {
            revert OperatorNotAllowed(auth);
        }
    }
}
