// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {ERC721URIStorage} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";

contract GLHFHonoraries is ERC721URIStorage, AccessControl {
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    uint256 _mintCounter;

    constructor(address admin) ERC721("GLHF Honoraries", "GLHF Honoraries") {
        _grantRole(DEFAULT_ADMIN_ROLE, admin);
    }

    function mint(address to, string memory _tokenURI) external onlyRole(MINTER_ROLE) {
        uint256 tokenId = _mintCounter++;
        _mint(to, tokenId);
        _setTokenURI(tokenId, _tokenURI);
    }

    function setTokenURI(uint256 tokenId, string memory _tokenURI) external onlyRole(DEFAULT_ADMIN_ROLE) {
        _setTokenURI(tokenId, _tokenURI);
    }

    function totalSupply() external view returns (uint256) {
        return _mintCounter;
    }

    function supportsInterface(
        bytes4 interfaceId
    ) public view virtual override(ERC721URIStorage, AccessControl) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
