// contracts/D3Casino.sol
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;
import "hardhat/console.sol";

contract D3CasinoD323{
    uint256 constant mod = 17;
    uint256 constant SAFE_GAS = 10000;
    uint256 public lasttime;
    mapping(address => uint256) public scores;
    mapping(address => bool) public betrecord;
    event SendFlag();

    constructor() {
        lasttime = block.timestamp;
    }

    function bet() public {
        require(lasttime != block.timestamp, "You can only bet once per block");
        require(
            betrecord[msg.sender] == false,
            "You can only bet once per contract"
        );

        assembly {
            let size := extcodesize(caller())
            if gt(size, 0x64) {
                invalid()
            }
        }

        lasttime = block.timestamp;
        betrecord[msg.sender] = true;
        uint256 rand = uint256(
            keccak256(
                abi.encodePacked(block.timestamp, /*block.difficulty,*/ msg.sender)
            )
        ) % mod;

        uint256 value;
        bool success;
        bytes memory result;
        (success, result) = msg.sender.staticcall{gas: SAFE_GAS}("");
        require(success, "Call failed!");
        value = abi.decode(result, (uint256));
        if (rand == value) {
            uint256 score;
            for (uint i = 0; i < 20; i++) {
                if (bytes20(msg.sender)[i] == 0 && bytes20(tx.origin)[i] == 0) {
                    score++;
                }
            }
            scores[tx.origin] += score;
        } else {
            scores[tx.origin] = 0;
        }
    }

    function Solve() public {
        require(
            scores[msg.sender] >= 10,
            "You Don't Have Enough Score To Solve The Challenge"
        );
        emit SendFlag();
    }
}