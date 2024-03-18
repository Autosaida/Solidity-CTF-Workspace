import { ethers } from "ethers";

function help(){
    let char: string[] = [];
    let checker: { [key: string]: boolean } = {};
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
    for(let i = 0; i < 32; i++) {
        let b = ethers.zeroPadBytes(ethers.toUtf8Bytes(char[i]), 32);
        let hex = ethers.hexlify(b);
        let value = checker[char[i]] == true? BigInt(1) << BigInt(0xf8) : 0;
        console.log(`checker[${hex}]=0x${value.toString(16)};`);
    }
    process.exit(0);
}

async function main() {
    help();
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});