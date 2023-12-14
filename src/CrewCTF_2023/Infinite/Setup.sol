// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./CrewToken.sol";
import "./RespectToken.sol";
import "./CandyToken.sol";
import "./FancyStore.sol";
import "./LocalGang.sol";

contract Setup {

    CrewToken public immutable CREW;
    RespectToken public immutable RESPECT;
    CandyToken public immutable CANDY;
    FancyStore public immutable STORE;
    LocalGang public immutable GANG;

    constructor() payable {
        CREW = new CrewToken();
        RESPECT = new RespectToken();
        CANDY = new CandyToken();   
        STORE = new FancyStore(address(CANDY), address(RESPECT), address(CREW));
        GANG = new LocalGang(address(CANDY), address(RESPECT));

        RESPECT.transferOwnership(address(GANG));
        CANDY.transferOwnership(address(STORE));
    }

    function isSolved() public view returns (bool) {
        return STORE.respectCount(CREW.receiver())>=50; // notice: not balance
    }
}
