// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC721Enumerable} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract RWANFT is ERC721Enumerable, Ownable {
    uint256 private _nextTokenId;
    uint96 public maxSupply;
    string public tokenUri;

    constructor(
        string memory name_,
        string memory symbol_,
        uint96 maxSupply_,
        string memory tokenUri_
    ) ERC721(name_, symbol_) Ownable() {
        maxSupply = maxSupply_;
        tokenUri = tokenUri_;
    }

    function tokenURI(
        uint256 tokenId
    ) public view virtual override returns (string memory) {
        _exists(tokenId);

        return tokenUri;
    }

    function batchMint(address recipient, uint256 numTokens) public onlyOwner {
        require(_nextTokenId + numTokens <= maxSupply, "Exceeds MAX_SUPPLY");

        for (uint256 i = 0; i < numTokens; i++) {
            _nextTokenId++;
            _mint(recipient, _nextTokenId);
        }
    }

    function burn(uint256 tokenId) public virtual {
        require(_isApprovedOrOwner(_msgSender(), tokenId), "caller is not owner nor approved");
        _burn(tokenId);
    }
}
