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
        vm.startPrank(deployer, deployer);
        deal(attacker, 1 ether);

        SpaceToken token = new SpaceToken();
        SpaceBank spacebank = new SpaceBank(address(token));
        token.mint(address(spacebank), 1000);
        challenge = new Challenge(spacebank);

        vm.stopPrank();
        console2.log("setUp done!");
    }

    function testExploit() public {
        vm.startPrank(attacker, attacker);

        solve();
        console.log("isSolved:", challenge.isSolved());

        vm.stopPrank();
    }

    function solve() public {
        SpaceBankAttack attack = new SpaceBankAttack{value: 1 wei}(challenge);
        
        attack.solve();
        vm.roll(block.number + 2);
        // vm.sleep(1000);
        attack.finish();
    }
}


