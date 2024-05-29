// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC721Enumerable} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract RWANFT is ERC721Enumerable, Ownable {
    uint256 private _nextTokenId;
    uint96 public max_supply;
    string public token_uri;

    constructor(
        string memory name_,
        string memory symbol_,
        uint96 max_supply_,
        string memory token_uri_
    ) ERC721(name_, symbol_) Ownable(msg.sender) {
        max_supply = max_supply_;
        token_uri = token_uri_;
    }

    function tokenURI(
        uint256 tokenId
    ) public view virtual override returns (string memory) {
        _requireOwned(tokenId);

        return token_uri;
    }

    function batchMint(address recipient, uint256 numTokens) public onlyOwner {
        require(_nextTokenId + numTokens <= max_supply, "Exceeds MAX_SUPPLY");

        for (uint256 i = 0; i < numTokens; i++) {
            _nextTokenId++;
            _mint(recipient, _nextTokenId);
        }
    }

    function burn(uint256 tokenId) public virtual {
        _update(address(0), tokenId, msg.sender);
    }
}
