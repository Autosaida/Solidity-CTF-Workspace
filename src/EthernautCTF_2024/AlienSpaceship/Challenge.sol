// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Challenge {
    AlienSpaceship public immutable ALIENSPACESHIP;

    constructor(address alienspaceship) {
        ALIENSPACESHIP = AlienSpaceship(alienspaceship);
    }

    function isSolved() external view returns (bool) {
        return ALIENSPACESHIP.missionAborted();  // cast sig "missionAborted()" -> 0xe7511d8d
    }
}

interface AlienSpaceship {
    function missionAborted() external view returns (bool);
}