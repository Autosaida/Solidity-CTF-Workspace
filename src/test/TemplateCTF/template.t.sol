// SPDX-License-Identifier: MIT
pragma solidity >=0.6.2 <0.9.0;

import "forge-std/Test.sol";
import "forge-std/Script.sol";
import "forge-std/console2.sol";
import "src/TemplateCTF/TemplateChallenge/Challenge.sol";
import "./ChallengeAttack.sol";


contract Attacker is Test, Script {
    address deployer = makeAddr("deployer");
    uint256 attacker_key = vm.envUint("ATTACKER_KEY");
    address attacker = vm.addr(attacker_key);

    Challenge challenge;

    function setUp() public {
        vm.createSelectFork("mainnet");
        // Directly use the mainnet for reproducing challenges
        // vm.createSelectFork("http://localhost:8545");
        // Use the provided RPC during CTF competitions
        vm.startPrank(deployer, deployer);
        deal(deployer, 10000 ether);
        deal(attacker, 1 ether);

        challenge = new Challenge("template");

        vm.stopPrank();
        console2.log("setUp done!");
    }

    // forge test --contracts .\src\test\TemplateCTF\template.t.sol -vvv
    function testExploit() public {
        // Call the solver's function with the attacker identity to test
        vm.startPrank(attacker, attacker);

        solve();
        console.log("isSolved:", challenge.isSolved());
        assertEq(challenge.isSolved(), true);

        vm.stopPrank();
    }

    function solve() public {
        // Implement specific challenge-solving logic in the solver contract, similar to typescript scripts.
        ChallengeAttack challengeAttack = new ChallengeAttack();
        challengeAttack.set(address(challenge));
    }

    // forge script --contracts .\src\test\TemplateCTF\templateScript.t.sol --slow .\src\test\TemplateCTF\templateScript.t.sol --broadcast
    function run() public {
        // Broadcast transactions, similar to tests, just need set the actual address of the instance.
        vm.startBroadcast(attacker_key);

        // challenge = Challenge(0xxxx);
        solve();
        console.log("isSolved:", challenge.isSolved());
        
        vm.stopBroadcast();
    }
}


