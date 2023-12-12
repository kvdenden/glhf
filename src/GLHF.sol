// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {IERC165} from "@openzeppelin/contracts/utils/introspection/IERC165.sol";
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {ERC721Royalty} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Royalty.sol";
import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";

import {IMintableERC721} from "./interfaces/IMintableERC721.sol";
import {ITokenRenderer} from "./interfaces/ITokenRenderer.sol";

contract GLHF is ERC721Royalty, AccessControl, IMintableERC721 {
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    uint256 public constant MAX_SUPPLY = 5000;

    ITokenRenderer public renderer;

    uint256 _nextIndex;

    constructor(address admin, address treasury) ERC721("GLHF", "GLHF") {
        _grantRole(DEFAULT_ADMIN_ROLE, admin);
        _setDefaultRoyalty(treasury, 420);
    }

    function mint(address to, uint256 quantity) external onlyRole(MINTER_ROLE) returns (uint256[] memory) {
        uint256 startTokenId = _nextIndex;
        require(startTokenId + quantity <= MAX_SUPPLY, "Exceeds max supply");

        for (uint256 i; i < quantity; i++) {
            _mint(to, startTokenId + i);
        }
        _nextIndex += quantity;

        return _range(startTokenId, quantity);
    }

    function burn(uint256 tokenId) external {
        _update(address(0), tokenId, _msgSender());
    }

    function totalSupply() external view returns (uint256) {
        return _nextIndex;
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

    function _range(uint256 from, uint256 length) internal pure returns (uint256[] memory result) {
        result = new uint256[](length);
        for (uint256 i; i < length; i++) {
            result[i] = from + i;
        }
    }
}
