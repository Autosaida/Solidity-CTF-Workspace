// SPDX-License-Identifier: MIT
pragma solidity >=0.6.2 <0.9.0;

import "forge-std/Test.sol";
import "forge-std/Script.sol";
import "forge-std/console2.sol";
import "src/SCTF_2023/DamnBrackets/DamnBrackets.sol";
import "src/SCTF_2023/DamnBrackets/DamnBracketsAttack.sol";


contract Exploiter is Test, Script {
    address deployer = makeAddr("deployer");
    uint256 attacker_key = vm.envUint("ATTACKER_KEY");
    address attacker = vm.addr(attacker_key);

    DamnBrackets damnBrackets;

    function setUp() public {
        vm.createSelectFork("mainnet");
        // vm.createSelectFork("http://localhost:8545");

        vm.startPrank(deployer, deployer);

        damnBrackets = new DamnBrackets();

        vm.stopPrank();
        console2.log("setUp done!");
    }

    function testExploit1() public {
        vm.startPrank(attacker, attacker);

        solve1();
        console2.log("isSolved:", damnBrackets.isSolved());
        assertEq(damnBrackets.isSolved(), true);

        vm.stopPrank();
    }

    function solve1() public {
        DamnBracketsAttack1 damnBracketsAttacker = new DamnBracketsAttack1();
        damnBrackets.solve(address(damnBracketsAttacker));
    }

    function testExploit2() public {
        vm.startPrank(attacker, attacker);

        solve2();
        console2.log("isSolved:", damnBrackets.isSolved());
        assertEq(damnBrackets.isSolved(), true);

        vm.stopPrank();
    }

    function solve2() public {
        DamnBracketsAttack2 damnBracketsAttacker = new DamnBracketsAttack2();
        damnBracketsAttacker.clone(address(damnBracketsAttacker));
        damnBrackets.solve(address(damnBracketsAttacker.proxyAddress()));
        console2.log("Proxy contract size: %d bytes", address(damnBracketsAttacker.proxyAddress()).code.length);
        console2.log("Implementation contract size: %d bytes", address(damnBracketsAttacker).code.length);
    }

    function run() public {
        vm.startBroadcast(attacker_key);

        // damnBrackets = DamnBrackets(0xxxx);
        solve1();
        console2.log("isSolved:", damnBrackets.isSolved());

        vm.stopBroadcast();
    }
}

