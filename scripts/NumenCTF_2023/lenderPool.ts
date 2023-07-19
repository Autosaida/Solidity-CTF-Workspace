import chalk from "chalk";
import { ethers } from "hardhat";
import { LenderPoolCheckNumen23__factory, LenderPoolCheckNumen23, LenderPoolNumen23Attack__factory } from "../../typechain";
import { log, initialize } from "../utils";


async function main() {
    let [lenderPoolCheckNumen23Contract, attacker] = await initialize<LenderPoolCheckNumen23>(LenderPoolCheckNumen23__factory);

    const lenderPoolNumen23Attack = await new LenderPoolNumen23Attack__factory(attacker).deploy();
    await lenderPoolNumen23Attack.waitForDeployment();
    const lenderPool = await lenderPoolCheckNumen23Contract.lenderPool();
    let tx = await lenderPoolNumen23Attack.attack(lenderPool);
    await tx.wait();
    log(`Is solved: ${chalk.yellow(await lenderPoolCheckNumen23Contract.isSolved())}`);
    
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});