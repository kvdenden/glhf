// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.23;

import { AccessControl } from "@openzeppelin/contracts/access/AccessControl.sol";
import { Address } from "@openzeppelin/contracts/utils/Address.sol";
import { AuctionHouse } from "./AuctionHouse.sol";

contract AuctionHouseManager is AccessControl {
  bytes32 public constant OPERATOR_ROLE = keccak256("OPERATOR_ROLE");

  AuctionHouse public immutable auctionHouse;

  constructor(AuctionHouse auctionHouse_, address admin) {
    require(address(auctionHouse_) != address(0), "Invalid auction house");
    require(admin != address(0), "Invalid admin");

    auctionHouse = auctionHouse_;
    _grantRole(DEFAULT_ADMIN_ROLE, admin);
    _grantRole(OPERATOR_ROLE, admin);
  }

  function pause() external onlyRole(OPERATOR_ROLE) {
    auctionHouse.pause();
  }

  function unpause() external onlyRole(OPERATOR_ROLE) {
    auctionHouse.unpause();
  }

  function setTimeBuffer(uint256 timeBuffer) external onlyRole(OPERATOR_ROLE) {
    auctionHouse.setTimeBuffer(timeBuffer);
  }

  function setReservePrice(uint256 reservePrice) external onlyRole(OPERATOR_ROLE) {
    auctionHouse.setReservePrice(reservePrice);
  }

  function setMinBidIncrementPercentage(uint8 minBidIncrementPercentage)
    external
    onlyRole(OPERATOR_ROLE)
  {
    auctionHouse.setMinBidIncrementPercentage(minBidIncrementPercentage);
  }

  function setDuration(uint256 duration) external onlyRole(OPERATOR_ROLE) {
    auctionHouse.setDuration(duration);
  }

  function execute(bytes calldata data)
    external
    onlyRole(DEFAULT_ADMIN_ROLE)
    returns (bytes memory)
  {
    return Address.functionCall(address(auctionHouse), data);
  }
}
