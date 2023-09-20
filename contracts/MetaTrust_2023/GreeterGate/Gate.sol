// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GateMetaTrust23 {
        bool public locked = true;  // slot0

        uint256 public timestamp = block.timestamp; // slot1
        uint8 private number1 = 10;   // slot2
        uint16 private number2 = 255;  // slot2
        bytes32[3] private data;  // slot 3 4 5

  constructor(bytes32  _data1,bytes32  _data2,bytes32  _data3) {
     data[0] = _data1;
     data[1] = _data2;
     data[2] = _data3;
  }

    modifier onlyThis() {
        require(msg.sender == address(this), "Only the contract can call this");
        _;
    }

 function resolve(bytes memory _data) public {
    require(msg.sender != tx.origin);
    (bool success, ) = address(this).call(_data);
     require(success, "call failed");
  }

   function unlock(bytes memory _data) public onlyThis {
       require(bytes16(_data) == bytes16(data[2]));
       locked = false;
   }

    function isSolved() public view returns (bool) {
	    return !locked;
    }


}