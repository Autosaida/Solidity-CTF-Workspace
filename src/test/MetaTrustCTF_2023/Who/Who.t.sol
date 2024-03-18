// SPDX-License-Identifier: MIT
pragma solidity >=0.6.2 <0.9.0;

import "forge-std/Test.sol";
import "forge-std/Script.sol";
import "forge-std/console2.sol";
import "./FooAttack.sol";


contract Attacker is Test, Script {
    address deployer = makeAddr("deployer");
    uint256 attacker_key = vm.envUint("ATTACKER_KEY");
    address attacker = vm.addr(0xf2b6c9639f151c02b3dac23920d699ef3792e75756db1e34cf141cc9ffe9b726);

    Foo foo;

    function setUp() public {
        vm.createSelectFork("mainnet");
        vm.startPrank(deployer, deployer);
        deal(deployer, 1 ether);

        foo = new Foo();

        vm.stopPrank();
        console2.log("setUp done!");
    }

    function testExploit() public {
        vm.startPrank(attacker, attacker);

        solve();
        console.log("isSolved:", foo.isSolved());
        vm.stopPrank();
    }

    function solve() public {
        FooAttack attack = new FooAttack();
        attack.attack(address(foo));
        
    }
}


