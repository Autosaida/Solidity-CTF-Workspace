import chalk from "chalk";
import { ethers } from "hardhat";
import { Challenge__factory, Challenge, ChallengeAttack__factory } from "../../typechain";
import { log, initialize } from "../utils";

function help(){
    // something helpful when solving but not used fanally
}

async function main() {
    let attackerPrivateKey = "0x0000";
    let constructorArgs: any[] = [];
    let contractAddress = "0x0000";
    let [challengeContract, attacker] = await initialize<Challenge>(Challenge__factory, attackerPrivateKey, constructorArgs, contractAddress);
    
    const challengeAttack = await new ChallengeAttack__factory(attacker).deploy();
    await challengeAttack.waitForDeployment();

    // log(``);
    
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});