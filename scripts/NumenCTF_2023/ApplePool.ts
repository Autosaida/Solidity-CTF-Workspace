import chalk from "chalk";
import { ethers } from "hardhat";
import { ApplePoolCheckNumen23__factory, ApplePoolCheckNumen23, ApplePoolAttackNumen23__factory } from "../../typechain";
import { log, initialize } from "../utils";

async function main() {
    let [applePoolCheckContract, attacker] = await initialize<ApplePoolCheckNumen23>(ApplePoolCheckNumen23__factory); 

    let applePoolAttack = await new ApplePoolAttackNumen23__factory(attacker).deploy();
    let tx = await applePoolAttack.attack(await applePoolCheckContract.getAddress());
    await tx.wait();
    log(`Is solved: ${chalk.yellow(await applePoolCheckContract.isSolved())}`);

}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});