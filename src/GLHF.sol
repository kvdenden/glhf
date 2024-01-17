// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {IERC165} from "@openzeppelin/contracts/utils/introspection/IERC165.sol";
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {ERC721Royalty} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Royalty.sol";
import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";

import {IMintableERC721} from "./interfaces/IMintableERC721.sol";
import {ITokenRenderer} from "./interfaces/ITokenRenderer.sol";
import {ITokenUpdateHandler} from "./interfaces/ITokenUpdateHandler.sol";

contract GLHF is ERC721Royalty, AccessControl, IMintableERC721 {
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    uint256 public immutable maxSupply = 3690;

    ITokenRenderer public renderer;
    ITokenUpdateHandler public updateHandler;

    uint256 _mintCounter;

    constructor(address admin, address treasury) ERC721("GLHF", "GLHF") {
        _grantRole(DEFAULT_ADMIN_ROLE, admin);
        _setDefaultRoyalty(treasury, 50);
    }

    function mint(address to, uint256 quantity) external onlyRole(MINTER_ROLE) returns (uint256[] memory) {
        uint256 startTokenId = _mintCounter;
        require(startTokenId + quantity <= maxSupply, "Exceeds max supply");

        for (uint256 i; i < quantity; i++) {
            _mint(to, startTokenId + i);
        }
        _mintCounter += quantity;

        return _range(startTokenId, quantity);
    }

    function totalSupply() external view returns (uint256) {
        return _mintCounter;
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        _requireOwned(tokenId);

        return renderer.tokenURI(tokenId);
    }

    function supportsInterface(
        bytes4 interfaceId
    ) public view virtual override(ERC721Royalty, AccessControl, IERC165) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function setRoyalty(address recipient, uint96 feeNumerator) external onlyRole(DEFAULT_ADMIN_ROLE) {
        _setDefaultRoyalty(recipient, feeNumerator);
    }

    function setRenderer(ITokenRenderer renderer_) external onlyRole(DEFAULT_ADMIN_ROLE) {
        require(address(renderer_) != address(0), "Can't set to zero address");

        renderer = renderer_;
    }

    function setTokenUpdateHandler(ITokenUpdateHandler handler_) external onlyRole(DEFAULT_ADMIN_ROLE) {
        updateHandler = handler_;
    }

    function _update(address to, uint256 tokenId, address auth) internal virtual override returns (address) {
        if (address(updateHandler) != address(0)) {
            updateHandler.handleUpdate(address(this), to, tokenId, auth);
        }

        return super._update(to, tokenId, auth);
    }

    function _range(uint256 from, uint256 length) internal pure returns (uint256[] memory result) {
        result = new uint256[](length);
        for (uint256 i; i < length; i++) {
            result[i] = from + i;
        }
    }
}
