import chalk from "chalk";
import { ethers } from "hardhat";
import { CollatzPuzzleQuill__factory, CollatzPuzzleQuill, CollatzPuzzleQuillAttack__factory } from "../../typechain";
import { log, initialize } from "../utils";


async function main() {
    let [collatzPuzzleQuillContract, attacker] = await initialize<CollatzPuzzleQuill>(CollatzPuzzleQuill__factory);
    let attack = await new CollatzPuzzleQuillAttack__factory(attacker).deploy();
    await attack.waitForDeployment();

    log(`Is solved: ${chalk.yellow(await collatzPuzzleQuillContract.callMe(await attack.getAddress()))}`); 
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});