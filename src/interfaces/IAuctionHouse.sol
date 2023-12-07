// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.6;

// @author Modified from Nouns (https://github.com/nounsDAO/nouns-monorepo/blob/master/packages/nouns-contracts/contracts/interfaces/INounsAuctionHouse.sol)
interface IAuctionHouse {
    struct Auction {
        // ERC721 token ID
        uint256 tokenId;
        // The current highest bid amount
        uint256 amount;
        // The time that the auction started
        uint256 startTime;
        // The time that the auction is scheduled to end
        uint256 endTime;
        // The address of the current highest bid
        address payable bidder;
        // Whether or not the auction has been settled
        bool settled;
    }

    event AuctionCreated(uint256 indexed tokenId, uint256 startTime, uint256 endTime);

    event AuctionBid(uint256 indexed tokenId, address sender, uint256 value, bool extended);

    event AuctionExtended(uint256 indexed tokenId, uint256 endTime);

    event AuctionSettled(uint256 indexed tokenId, address winner, uint256 amount);

    event AuctionTimeBufferUpdated(uint256 timeBuffer);

    event AuctionReservePriceUpdated(uint256 reservePrice);

    event AuctionMinBidIncrementPercentageUpdated(uint256 minBidIncrementPercentage);

    event AuctionDurationUpdated(uint256 duration);

    event AuctionTreasuryUpdated(address treasury);

    function settleAuction() external;

    function settleCurrentAndCreateNewAuction() external;

    function createBid(uint256 tokenId) external payable;
}
