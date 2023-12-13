// SPDX-License-Identifier: MIT
pragma solidity >=0.6.2 <0.9.0;

import "forge-std/Test.sol";
import "forge-std/Script.sol";
import "forge-std/console2.sol";
import "src/TemplateCTF/TemplateChallenge/Challenge.sol";
import "src/TemplateCTF/TemplateChallenge/ChallengeAttack.sol";


contract Exploiter is Test, Script {
    address deployer = makeAddr("deployer");
    uint256 attacker_key = vm.envUint("ATTACKER_KEY");
    address attacker = vm.addr(attacker_key);

    Challenge c;

    function setUp() public {
        vm.createSelectFork("mainnet");
        // directly use the mainnet for reproducing challenges
        // vm.createSelectFork("http://localhost:8545");
        // Use the provided RPC during CTF competitions
        vm.startPrank(deployer, deployer);

        c = new Challenge("template");

        vm.stopPrank();
        console2.log("setUp done!");
    }

    // forge test --contracts .\src\test\TemplateCTF\template.t.sol -vvv
    function testExploit() public {
        // call the solver's function with the attacker identity to test
        vm.startPrank(attacker, attacker);

        solve();
        console.log("isSolved:",c.isSolved());
        assertEq(c.isSolved(), true);

        vm.stopPrank();
    }

    function solve() public {
        // Implement specific challenge-solving logic in the solver contract, similar to typescript scripts.
        ChallengeAttack ca = new ChallengeAttack();
        ca.set(address(c));
    }

    // forge script .\src\test\TemplateCTF\template.t.sol:Exploiter --slow --skip-simulation --broadcast
    function run() public {
        // Broadcast transactions, similar to tests, just need set the actual address of the instance.
        vm.startBroadcast(attacker_key);

        // c = Challenge(0xxxx);
        solve();
        console.log("isSolved:", c.isSolved());
        
        vm.stopBroadcast();
    }
}


