// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

import "./ISlotPuzzleFactory.sol";
import "hardhat/console.sol";

contract SlotPuzzleQuill {
    bytes32 public immutable ghost = 0x68747470733a2f2f6769746875622e636f6d2f61726176696e64686b6d000000;    
    ISlotPuzzleFactoryQuill public factory;      // slot 0

    struct ghostStore {
        bytes32[] hash;
        mapping (uint256 => mapping (address => ghostStore)) map;
    }

    mapping(address => mapping (uint256 => ghostStore)) private ghostInfo;   // slot 1

    error InvalidSlot();

    constructor() {
        uint salt;
        if (block.number > block.basefee) {
            salt = block.number - block.basefee;
        } else {
            salt = block.basefee - block.number;
        }
        ghostInfo[tx.origin][block.number]
        .map[block.timestamp][msg.sender]
        .map[block.prevrandao][block.coinbase]
        .map[block.chainid][address(uint160(uint256(blockhash(salt))))]
        .hash.push(ghost);      // store ghost

        factory = ISlotPuzzleFactoryQuill(msg.sender);
    }

    function ascertainSlot(Parameters calldata params) external returns (bool status) {
        require(address(factory) == msg.sender);
        require(params.recipients.length == params.totalRecipients);

        bytes memory slotKey = params.slotKey;  // 0x80
        bytes32 slot;
        uint256 offset = params.offset;

        assembly {
            offset := calldataload(offset)
            slot := calldataload(add(slotKey,offset))   // load: 0x80+offset
        }
        
        getSlotValue(slot, ghost);
        // getSlotValue(bytes32(slotKey), ghost);
        // console.logBytes(msg.data);
        // console.log(msg.data.length);  // 452
        for(uint8 i=0;i<params.recipients.length;i++) {
            factory.payout(             // get eth
                params.recipients[i].account,
                params.recipients[i].amount
            );
        }

        return true;
    }

    function getSlotValue(bytes32 slot,bytes32 validResult) internal view {      
        bool validOffsets;
        assembly {
            validOffsets := eq(
                sload(slot),
                validResult
            )
        }

        if (!validOffsets) {
            revert InvalidSlot();
        }
    }

    function getGhostGit() public pure returns (string memory) {
        return string(abi.encodePacked(ghost));
    }    
}