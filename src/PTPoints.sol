// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract PTPoints is ERC20, Ownable {
    constructor() ERC20("Points", "PT") Ownable() {}

    function mint(address to, uint256 amount) public onlyOwner{
        _mint(to, amount);
    }

    function burnFromContractOwner(address from, uint256 amount) public onlyOwner returns (bool) {
        _burn(from, amount);
        return true;
    }

    function burn(uint256 amount) public returns (bool) {
        address owner = _msgSender();
        _burn(owner, amount);
        return true;
    }

    function burnFrom(address from, uint256 amount) public returns (bool) {
        address spender = _msgSender();
        _spendAllowance(from, spender, amount);
        _burn(from, amount);
        return true;
    }

}
