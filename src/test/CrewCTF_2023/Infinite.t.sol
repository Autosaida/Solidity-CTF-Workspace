// SPDX-License-Identifier: MIT
pragma solidity >=0.6.2 <0.9.0;
pragma abicoder v2;

import "forge-std/Test.sol";
import "forge-std/Script.sol";
import "forge-std/console2.sol";
import "src/CrewCTF_2023/Infinite/Setup.sol";
import "src/CrewCTF_2023/Infinite/InfiniteAttack.sol";

contract Exploiter is Test, Script {
    address deployer = makeAddr("deployer");
    uint256 attacker_key = vm.envUint("ATTACKER_KEY");
    address attacker = vm.addr(attacker_key);

    Setup setup;

    function setUp() public {
        vm.createSelectFork("mainnet");
        vm.startPrank(deployer, deployer);

        setup = new Setup();

        vm.stopPrank();
        console2.log("setUp done!");
    }

    function testExploit() public {
        vm.startPrank(attacker, attacker);

        solve();
        console.log("isSolved:", setup.isSolved());
        
        vm.stopPrank();

    }

    function solve() public {
        InfiniteAttack ia = new InfiniteAttack();
        ia.attack(address(setup));
    }

}


