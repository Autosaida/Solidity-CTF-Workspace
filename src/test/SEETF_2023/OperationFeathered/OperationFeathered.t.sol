// SPDX-License-Identifier: MIT
pragma solidity >=0.6.2 <0.9.0;

import "forge-std/Test.sol";
import "forge-std/Script.sol";
import "forge-std/console2.sol";
import "./PigeonAttack.sol";


contract Attacker is Test, Script {
    address deployer = makeAddr("deployer");
    uint256 attacker_key = vm.envUint("ATTACKER_KEY");
    address attacker = vm.addr(attacker_key);

    SetupPigeon setup;

    function setUp() public {
        vm.createSelectFork("mainnet");
        vm.startPrank(deployer, deployer);

        vm.deal(deployer, 30 ether);
        vm.deal(attacker, 5 ether);
        setup = new SetupPigeon{value: 30 ether}();

        vm.stopPrank();
        console2.log("setUp done!");
    }

    function testExploit1() public {
        vm.startPrank(attacker, attacker);

        solve1();
        console2.log("isSolved: ", setup.isSolved());
        vm.stopPrank();

    }

    function solve1() public {
        Pigeon pigeon = setup.pigeon();
        PigeonAttack pa = new PigeonAttack();
        pa.attack1(address(pigeon));
    }

    function testExploit2() public {
        vm.startPrank(attacker, attacker);

        solve2();
        console2.log("isSolved: ", setup.isSolved());
        vm.stopPrank();

    }

    function solve2() public {
        Pigeon pigeon = setup.pigeon();
        PigeonAttack pa = new PigeonAttack();
        pa.attack2(address(pigeon));
    }

}


