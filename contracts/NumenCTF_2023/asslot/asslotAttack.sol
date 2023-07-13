// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
import "./asslot.sol";
import "@openzeppelin/contracts/proxy/Clones.sol";
import "hardhat/console.sol";

contract AsslotAttack {
    address public proxyAddress;

    function clone() public {
        proxyAddress = Clones.clone(address(this));
    }

    function solve(address target) public {
        Asslot a = Asslot(target);
        a.f00000000_bvvvdlt();
    }

    fallback(bytes calldata /*data*/) external returns(bytes memory retVal) {
        if (gasleft() < 249000) {
            console.log(gasleft());
            return abi.encode(3);
        }
        else if (gasleft() < 250000) {
            console.log(gasleft());
            return abi.encode(2);
        }
        else if (gasleft() < 253000) {
            console.log(gasleft());
            return abi.encode(1);
        }
        else {
            console.log(gasleft());
            return abi.encode(0);
        }
    }

}


