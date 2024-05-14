// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC721URIStorage} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract RWANFT is ERC721URIStorage, Ownable {
    uint256 private _nextTokenId;
    uint256 public max_supply;
    string public token_uri;

    constructor(
        string memory name_,
        string memory symbol_,
        uint256 max_supply_,
        string memory token_uri_
    ) ERC721(name_, symbol_) Ownable(msg.sender) {
        max_supply = max_supply_;

        token_uri = token_uri_;
    }

    function batchMint(address recipient, uint256 numTokens) public onlyOwner {
        require(_nextTokenId + numTokens <= max_supply, "Exceeds MAX_SUPPLY");

        for (uint256 i = 0; i < numTokens; i++) {
            _nextTokenId++;

            _mint(recipient, _nextTokenId);
            _setTokenURI(_nextTokenId, token_uri);
        }
    }
}
