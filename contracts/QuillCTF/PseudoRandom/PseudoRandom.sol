// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import "hardhat/console.sol";

contract PseudoRandomQuill {
    error WrongSig();

    address public owner;

    constructor() {
        bytes32[3] memory input;
        input[0] = bytes32(uint256(1));
        input[1] = bytes32(uint256(2));
        owner = msg.sender;

        bytes32 scalar;
        assembly {
            scalar := sub(mul(timestamp(), number()), chainid())
        }
        input[2] = scalar;

        assembly {
            let success := call(gas(), 0x07, 0x00, input, 0x60, 0x00, 0x40)  // Note that an account with no code will return success as true.
            if iszero(success) {
                revert(0x00, 0x00)
            }

            let slot := xor(mload(0x00), mload(0x20))

            sstore(add(chainid(), origin()), slot)

            let sig := shl(
                0xe0,
                or(
                    and(scalar, 0xff000000),
                    or(
                        and(shr(xor(origin(), caller()), slot), 0xff0000),
                        or(
                            and(
                                shr(
                                    mod(xor(chainid(), origin()), 0x0f),
                                    mload(0x20)
                                ),
                                0xff00
                            ),
                            and(shr(mod(number(), 0x0a), mload(0x20)), 0xff)
                        )
                    )
                )
            )
            sstore(slot, sig)
        }
    }

    fallback() external {
        if (msg.sig == 0x3bc5de30) {  // getData()
            assembly {
                mstore(0x00, sload(calldataload(0x04)))
                return(0x00, 0x20)
            }
        } else {
            bytes4 sig;
            address _owner = owner;
            assembly {
                sig := sload(sload(add(chainid(), _owner)))
            }
            // console.logBytes4(sig);

            if (msg.sig != sig) {
                revert WrongSig();
            }

            assembly {
                sstore(owner.slot, calldataload(0x24))  // execute this
            }
        }
    }
}