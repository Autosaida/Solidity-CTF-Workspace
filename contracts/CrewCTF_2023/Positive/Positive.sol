// SPDX-License-Identifier: MIT
pragma solidity =0.7.6;
import "hardhat/console.sol";

contract PositiveCrew23{
    bool public solved;

    constructor() {
        solved = false;
    }

    function stayPositive(int64 _num) public returns(int64){
        int64 num;
        // console.logInt(type(int64).max);
        // console.logInt(type(int64).min);
        // console.logInt(_num);
        // console.logInt(-_num);
        if(_num<0){
            num = -_num;
            if(num<0){
                solved = true;
            }
            return num;
        }
        num = _num;
        return num;
    }

}