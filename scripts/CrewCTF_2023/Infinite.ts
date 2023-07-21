import chalk from "chalk";
import { ethers } from "hardhat";
import { SetupInfiniteCrew23__factory, SetupInfiniteCrew23, InfiniteCrew23Attack__factory } from "../../typechain";
import { log, initialize } from "../utils";


async function main() {
    let [setupInfiniteCrew23Contract, attacker] = await initialize<SetupInfiniteCrew23>(SetupInfiniteCrew23__factory);
    
    let infiniteCrew23Attack = await new InfiniteCrew23Attack__factory(attacker).deploy();
    await infiniteCrew23Attack.waitForDeployment();

    let tx = await infiniteCrew23Attack.attack(await setupInfiniteCrew23Contract.getAddress());
    await tx.wait();

    log(`Is solved: ${chalk.yellow(await setupInfiniteCrew23Contract.isSolved())}`);
    
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});