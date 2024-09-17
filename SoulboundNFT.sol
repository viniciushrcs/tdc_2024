// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract SoulboundNFT is ERC721, ERC721URIStorage, ERC721Pausable, AccessControl {
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    uint256 private _nextTokenId;

    constructor(address defaultAdmin, address pauser, address minter)
        ERC721("SoulboundNFT", "SBT")
    {
        _grantRole(DEFAULT_ADMIN_ROLE, defaultAdmin);
        _grantRole(PAUSER_ROLE, pauser);
        _grantRole(MINTER_ROLE, minter);
    }

    function pause() public onlyRole(PAUSER_ROLE) {
        _pause();
    }

    function unpause() public onlyRole(PAUSER_ROLE) {
        _unpause();
    }

    function safeMint(address to, string memory uri) public onlyRole(MINTER_ROLE) {
        uint256 tokenId = _nextTokenId++;
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
    }


    function _update(address to, uint256 tokenId, address auth)
        internal
        override(ERC721, ERC721Pausable)
        returns (address)
    {
        require(auth == address(0), "ERC721Soulbound: transfer is not allowed");
        return super._update(to, tokenId, auth);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function approve(address to, uint256 tokenId) public override(ERC721, IERC721) {
        revert("ERC721Soulbound: approve is not allowed");
    }

    function setApprovalForAll(address operator, bool approved) public override(ERC721, IERC721) {
        revert("ERC721Soulbound: approve is not allowed");
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721URIStorage, AccessControl)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}