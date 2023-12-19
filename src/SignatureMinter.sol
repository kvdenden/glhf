// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {MessageHashUtils} from "@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol";
import {SignatureChecker} from "@openzeppelin/contracts/utils/cryptography/SignatureChecker.sol";
import {BitMaps} from "@openzeppelin/contracts/utils/structs/BitMaps.sol";

import {IMintableERC721} from "./interfaces/IMintableERC721.sol";

contract SignatureMinter is Ownable {
    event SaleStatusChange(uint256 indexed saleId, bool enabled);

    using BitMaps for BitMaps.BitMap;

    struct SaleConfig {
        bool enabled;
        uint8 maxPerTransaction;
        uint64 unitPrice;
        address signerAddress;
    }

    IMintableERC721 public immutable tokens;

    uint256 private _maxSupply;

    mapping(uint256 => SaleConfig) private _saleConfig;
    mapping(uint256 => BitMaps.BitMap) private _allowlist;

    modifier canMint(
        uint256 saleId,
        address to,
        uint256 amount
    ) {
        _guardMint(to, amount);

        unchecked {
            SaleConfig memory saleConfig = _saleConfig[saleId];
            require(saleConfig.enabled, "Sale not enabled");
            require(amount <= saleConfig.maxPerTransaction, "Exceeds max per transaction");
            require(amount * saleConfig.unitPrice == msg.value, "Invalid funds provided");
        }

        _;
    }

    constructor(IMintableERC721 tokens_, address owner) Ownable(owner) {
        tokens = tokens_;
    }

    function allowlistMint(
        uint256 saleId,
        uint256 amount,
        uint256 nonce,
        bytes calldata signature
    ) external payable virtual canMint(saleId, _msgSender(), amount) {
        require(_validateSignature(saleId, nonce, signature), "Invalid signature");
        require(!_allowlist[saleId].get(nonce), "Nonce already used");

        _allowlist[saleId].set(nonce);

        _mint(_msgSender(), amount);
    }

    function getSaleConfig(uint256 saleId) external view returns (SaleConfig memory) {
        return _saleConfig[saleId];
    }

    function setSaleConfig(
        uint256 saleId,
        uint256 maxPerTransaction,
        uint256 unitPrice,
        address signerAddress
    ) external onlyOwner {
        _saleConfig[saleId].maxPerTransaction = uint8(maxPerTransaction);
        _saleConfig[saleId].unitPrice = uint64(unitPrice);
        _saleConfig[saleId].signerAddress = signerAddress;
    }

    function setSaleStatus(uint256 saleId, bool enabled) external onlyOwner {
        if (_saleConfig[saleId].enabled != enabled) {
            _saleConfig[saleId].enabled = enabled;
            emit SaleStatusChange(saleId, enabled);
        }
    }

    function getAllowlistNonceStatus(uint256 saleId, uint256 nonce) external view returns (bool) {
        BitMaps.BitMap storage allowlist = _allowlist[saleId];
        return allowlist.get(nonce);
    }

    function setAllowlistNonceStatus(uint256 saleId, uint256 nonce, bool value) external onlyOwner {
        BitMaps.BitMap storage allowlist = _allowlist[saleId];
        allowlist.setTo(nonce, value);
    }

    function getMaxSupply() external view returns (uint256) {
        return _maxSupply;
    }

    function setMaxSupply(uint256 maxSupply) external onlyOwner {
        _maxSupply = maxSupply;
    }

    function withdraw(address receiver) external onlyOwner {
        (bool success, ) = receiver.call{value: address(this).balance}("");
        require(success, "Withdrawal failed");
    }

    function _validateSignature(
        uint256 saleId,
        uint256 nonce,
        bytes calldata signature
    ) internal view virtual returns (bool) {
        bytes32 message = keccak256(abi.encodePacked(saleId, nonce, _msgSender()));
        bytes32 messageHash = MessageHashUtils.toEthSignedMessageHash(message);

        return SignatureChecker.isValidSignatureNow(_saleConfig[saleId].signerAddress, messageHash, signature);
    }

    function _guardMint(address /* to */, uint256 quantity) internal view virtual {
        require(tokens.totalSupply() + quantity <= _maxSupply, "Exceeds minter supply");
    }

    function _mint(address to, uint256 quantity) internal virtual {
        tokens.mint(to, quantity);
    }
}
