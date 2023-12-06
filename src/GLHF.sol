// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";

import {IMintable} from "./interfaces/IMintable.sol";
import {ITokenRenderer} from "./interfaces/ITokenRenderer.sol";

contract GLHF is ERC721, AccessControl, IMintable {
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    uint256 public constant MAX_SUPPLY = 5000;

    ITokenRenderer public renderer;

    uint256 _nextIndex;

    constructor() ERC721("GLHF", "GLHF") {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    function mint(address to, uint256 quantity) external onlyRole(MINTER_ROLE) {
        uint256 startTokenId = _nextIndex;
        require(startTokenId + quantity <= MAX_SUPPLY, "Exceeds max supply");

        for (uint256 i; i < quantity; i++) {
            _safeMint(to, startTokenId + i);
        }
        _nextIndex += quantity;
    }

    function totalSupply() external view returns (uint256) {
        return _nextIndex;
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        _requireOwned(tokenId);

        return renderer.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, AccessControl) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function setRenderer(ITokenRenderer renderer_) external onlyRole(DEFAULT_ADMIN_ROLE) {
        require(address(renderer_) != address(0), "Can't set to zero address");

        renderer = renderer_;
    }
}
