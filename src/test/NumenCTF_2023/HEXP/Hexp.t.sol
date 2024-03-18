// SPDX-License-Identifier: MIT
pragma solidity >=0.6.2 <0.9.0;
pragma abicoder v2;

import "forge-std/Test.sol";
import "forge-std/Script.sol";
import "forge-std/console2.sol";
import "src/NumenCTF_2023/HEXP/Hexp.sol";

contract Attacker is Test, Script {
    address deployer = makeAddr("deployer");
    uint256 attacker_key = vm.envUint("ATTACKER_KEY");
    address attacker = vm.addr(attacker_key);

    Hexp hexp;

    function setUp() public {
        vm.createSelectFork("mainnet");
        vm.startPrank(deployer, deployer);

        hexp = new Hexp();

        vm.stopPrank();
        console2.log("setUp done!");
    }

    function testExploit() public {
        vm.startPrank(attacker, attacker);

        solve();
        console.log("isSolved:", hexp.isSolved());
        vm.stopPrank();
    }

    function solve() public {
        // block.blockHash(block.number - 0x0a) & 0xffffff == gasprice & 0xffffff
        bytes32 hash = blockhash(block.number - 10);  // 10 maybe late
        vm.txGasPrice(uint256(hash));
        hexp.f00000000_bvvvdlt();
    }
}


