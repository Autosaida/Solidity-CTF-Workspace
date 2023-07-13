import chalk from "chalk";
import { ethers } from "hardhat";
import { DamnBrackets__factory, DamnBracketsAttack__factory } from "../../typechain";

// deployer: 0x84Efda7105a8E2116384dA59032456ff2B03e995
// token: v4.local.N_dsFnSljOOEcUgMbs4QGkU11PUPCaQ-10JKS_TAT57emAyZdoOBCccv64tI7VB2gtgsZbHR9f8JL748lntA_ox0b_VixUgP-iJogaCW3Yytkh2dv0vZ647pmlnPDB-yvzysn7FRkJpc1WBkoVw0zJ-zQhss-sbqJ_O-lI70U8TmWA.U2V0dXA

function log(s:string){
    console.log(`${chalk.green("[-] ")+s}`)
}

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
    const signers = await ethers.getSigners();
    const provider = ethers.provider;
    const network = await provider.getNetwork();
    const deployer = signers[0];
    const attacker = signers[2];

    log(`Running on the ${chalk.yellow(network.name)} network`);
    log(`Attacker address: ${chalk.yellow(attacker.address)}`);
    log(`Attacker balance: ${chalk.yellow(ethers.formatEther(await provider.getBalance(attacker)))} ETH`);

    let damnBracketsContract;
    let tx;
    if(network.name == "hardhat") {
        damnBracketsContract = await new DamnBrackets__factory(deployer).deploy();
        await damnBracketsContract.waitForDeployment();
        damnBracketsContract = damnBracketsContract.connect(attacker);
        log(`Successfully deployed the target contract to address ${chalk.yellow(await damnBracketsContract.getAddress())}!`)
    } else if (network.name == "remote") {
        const contractAddress = "0x26d6470416b2c8DE675C740a1E9363Ed590f220d";
        damnBracketsContract = DamnBrackets__factory.connect(contractAddress, attacker);
        log(`Successfully connected to the target contract with address ${chalk.yellow(await damnBracketsContract.getAddress())}!`)
    }
    // help();

    if(damnBracketsContract) {
        const damnBracketsAttack = await new DamnBracketsAttack__factory(attacker).deploy();
        await damnBracketsAttack.waitForDeployment();

        // solution a
        // const deployedCode = await damnBracketsAttack.getDeployedCode();
        // if (deployedCode) {
        //     const codeSize = ethers.dataLength(deployedCode);
        //     log(`Attack contract size: ${chalk.yellow(codeSize)} bytes`);
        // }

        // tx = await damnBracketsContract.solve(await damnBracketsAttack.getAddress());
        // await tx.wait();
        // log(`Is solved: ${chalk.yellow(await damnBracketsContract.isSolved())}`);

        // solution b
        tx = await damnBracketsAttack.clone(await damnBracketsAttack.getAddress());
        await tx.wait();
        const proxyAddress = await damnBracketsAttack.proxyAddress();
        const proxyCode = await provider.getCode(proxyAddress);
        const implementationCode = await damnBracketsAttack.getDeployedCode();
        if (proxyCode && implementationCode) {
            const proxySize = ethers.dataLength(proxyCode);
            const implementationSize = ethers.dataLength(implementationCode);
            log(`Proxy contract size: ${chalk.yellow(proxySize)} bytes`);
            log(`Implementation contract size: ${chalk.yellow(implementationSize)} bytes`);
        }
        
        tx = await damnBracketsContract.solve(proxyAddress);
        await tx.wait();
        log(`Is solved: ${chalk.yellow(await damnBracketsContract.isSolved())}`);
    }

}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});