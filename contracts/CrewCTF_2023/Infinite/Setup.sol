// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./CrewToken.sol";
import "./RespectToken.sol";
import "./CandyToken.sol";
import "./FancyStore.sol";
import "./LocalGang.sol";

contract SetupInfiniteCrew23 {

    CrewTokenCrew23 public immutable CREW;
    RespectTokenCrew23 public immutable RESPECT;
    CandyTokenCrew23 public immutable CANDY;
    FancyStoreCrew23 public immutable STORE;
    LocalGangCrew23 public immutable GANG;

    constructor() payable {
        CREW = new CrewTokenCrew23();
        RESPECT = new RespectTokenCrew23();
        CANDY = new CandyTokenCrew23();   
        STORE = new FancyStoreCrew23(address(CANDY), address(RESPECT), address(CREW));
        GANG = new LocalGangCrew23(address(CANDY), address(RESPECT));

        RESPECT.transferOwnership(address(GANG));
        CANDY.transferOwnership(address(STORE));
    }

    function isSolved() public view returns (bool) {
        return STORE.respectCount(CREW.receiver())>=50; // notice: not balance
    }
}
