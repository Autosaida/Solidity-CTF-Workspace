// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.12;
import "forge-std/console2.sol";

interface valid{
    function isValid(string memory ) external view returns(uint);
}

contract DamnBrackets {
    uint private solved ;
    mapping(uint=>string) private char;
    mapping(string=>bool) private checker;
    constructor(){
        char[0] = "({}{})";             checker["({}{})"] = true;
        char[1] = "[]{(}](])))";        checker["[]{(}](])))"] = false;
        char[2] = "{}{[]}";             checker["{}{[]}"] = true;
        char[3] = "(({))](([{";         checker["(({))](([{"] = false;
        char[4] = "(){(()()((";         checker["(){(()()(("] = false;
        char[5] = "{{()([]";            checker["{{()([]"] = false;
        char[6] = "({}}{((";            checker["({}}{(("] = false;
        char[7] = "}({[](]{}([}({";     checker["}({[](]{}([}({"] = false;
        char[8] = "(()){}";             checker["(()){}"] = true;
        char[9] = "[()]()";             checker["[()]()"] = true;
        char[10] = "(([]))";            checker["(([]))"] = true;
        char[11] = ")[{{}(](";          checker[")[{{}(]("] = false;
        char[12] = "))][{]]}";          checker["))][{]]}"] = false;
        char[13] = "(){}()";            checker["(){}()"] = true;
        char[14] = "{}[{}]";            checker["{}[{}]"] = true;
        char[15] = "](])]}{])(}}})";    checker["](])]}{])(}}})"] = false;
        char[16] = "{}{}[]";            checker["{}{}[]"] = true;
        char[17] = "}}()](}]][{((";     checker["}}()](}]][{(("] = false;
        char[18] = "((()))";            checker["((()))"] = true;
        char[19] = "[)}[(]])([)";       checker["[)}[(]])([)"] = false;
        char[20] = "}]](}{)";           checker["}]](}{)"] = false;
        char[21] = "[]{()}";            checker["[]{()}"] = true;
        char[22] = "()()()";            checker["()()()"] = true;
        char[23] = "([[{}]]{})";        checker["([[{}]]{})"] = true;
        char[24] = "){]([])";           checker["){]([])"] = false;
        char[25] = "[)[]({";            checker["[)[]({"] = false;
        char[26] = "(){[]}";            checker["(){[]}"] = true;
        char[27] = "[(]]}{]}{]";        checker["[(]]}{]}{]"] = false;
        char[28] = "{[]{()}}";          checker["{[]{()}}"] = true;
        char[29] = "{}]}]}{{{{{";       checker["{}]}]}{{{{{"] = false;
        char[30] = "{({{{]{][][[";      checker["{({{{]{][][["] = false;
        char[31] = "{}[]{}";            checker["{}[]{}"] = true;
    }

    function solve(address target) external  {
        uint x;
        assembly{
            x := extcodesize(target)
        }
        require(x > 0 && x <= 0xfb);
        for (uint i = 0;i<32;i++){
            uint res = valid(target).isValid(char[i])>>0xf8;
            bool flag = res == 0 ? false : true;
            bool flag0 = flag == checker[char[i]] ? true : false;
            if(flag0){
                solved++;
            }
            else{
                solved = 0;
            }
        }
    }

    function isSolved() external view returns (bool) {
        return solved >= 32;
    }
}