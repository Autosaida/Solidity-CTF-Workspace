import chalk from "chalk";
import { ethers } from "hardhat";
import { Challenge__factory, Challenge, ChallengeAttack__factory } from "../../typechain";
import { log, initialize } from "../utils";

function help(){
    // something helpful when solving but not used fanally
}

async function main() {
    let attackerPrivateKey = "0xad40ae6aba8ad4eb6f0164c8bff26f390fdf9407862edfd3efa91a62b02f49a2";
    let constructorArgs: any[] = [];
    let balance = "0";
    let contractAddress = "0x000000000000000000000000000000000000";
    let [challengeContract, attacker] = await initialize<Challenge>(Challenge__factory, attackerPrivateKey, constructorArgs, balance, contractAddress);
    
    const challengeAttack = await new ChallengeAttack__factory(attacker).deploy();
    await challengeAttack.waitForDeployment();

    // log(``);
    
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});