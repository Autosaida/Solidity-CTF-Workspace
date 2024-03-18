// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "forge-std/console2.sol";

contract A {
    function number() pure external returns(uint256){
        return 10;
    }
}

contract MyToken is ERC20 {
    constructor() ERC20("MyToken", "MTK") {
        _mint(msg.sender,100);
    }
}

contract GuessGame {
    // For constant variables, the value has to be fixed at compile-time, while for immutable, it can still be assigned at construction time.
    // The compiler does not reserve a storage slot for these variables, and every occurrence is replaced by the respective value.
    // For a constant variable, the expression assigned to it is copied to all the places where
    // it is accessed and also re-evaluated each time. This allows for local optimizations. 
    // Immutable variables are evaluated once at construction time and their value is copied to
    // all the places in the code where they are accessed. 

    // There are no restrictions on reading immutable variables. 
    // uint256 public immutable random01;
    // uint256 public immutable random02;
    // uint256 public immutable random03;
    uint256 private immutable random01;
    uint256 private immutable random02;
    uint256 private immutable random03;
    A private  immutable random04;
    MyToken private immutable mytoken;

    constructor(A _a) {
        mytoken = new MyToken();

        random01 = uint160(msg.sender);
        random02 = uint256(keccak256(address(new A()).code));
        random03 = block.timestamp;
        random04 = _a; 
        pureFunc();
    }

    function pureFunc() pure internal {
        assembly{
            mstore(0x80,1)
            mstore(0xa0,2)
            mstore(0xc0,32)
            // override the origin immutable vars' value
        }
    }

    function guess(uint256 _random01, uint256 _random02, uint256 _random03, uint256 _random04) external payable returns(bool){
        if(msg.value > 100 ether){
            // 100 eth! you are VIP!
        } else {
            uint256[] memory arr;
            uint256 money = msg.value;
            assembly{
                mstore(_random01, money)  // _random01->offset  money->value
            }
            require(random01 == arr.length,"wrong number01");  // could find the offset 0x60 by decompiling, but why it occupy the 0x60(zero slot)
            // console2.log(arr.length);
        }
        uint256 y = (uint160(address(msg.sender)) + random01 + random02 + random03 + _random02) & 0xff; // (msg.sender + 1+2+32+?)&0xff = 2
        require(random02 == y,"wrong number02");

        require(uint160(_random03) < uint160(0x0000000000fFff8545DcFcb03fCB875F56bedDc4));
        (,bytes memory data) = address(uint160(_random03)).staticcall("Fallbacker()");
        // https://www.evm.codes/precompiled
        // console.logBytes(data);  // RIPEMD-160 0x000000000000000000000000aa7478343ba23614098f5523990cbd50e4b7c2fd
        require(random03 == data.length,"wrong number03");

        require(random04.number() == _random04, "wrong number04");

        mytoken.transfer(msg.sender,100);
        payable(msg.sender).transfer(address(this).balance);

        return true;
    }

    function isSolved() external view returns(bool){
        return mytoken.balanceOf(address(this)) == 0;
    }
}


contract Setup {

    A public a ;
    GuessGame public guessGame;

    constructor() payable {
        a = new A();
        guessGame = new GuessGame(a);
    }

    function isSolved() public view returns(bool) {
        return guessGame.isSolved();
    }
}