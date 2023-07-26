import chalk from "chalk";
import { ethers } from "hardhat";
import { SetupPigeonSEETF23__factory, SetupPigeonSEETF23, PigeonAttackSEETF23__factory } from "../../typechain";
import { log, initialize } from "../utils";


async function main() {
    let [setupPigeonSEETF23Contract, attacker] = await initialize<SetupPigeonSEETF23>(SetupPigeonSEETF23__factory, undefined, undefined, "30");

    let pigeonAttack = await new PigeonAttackSEETF23__factory(attacker).deploy();
    await pigeonAttack.waitForDeployment();
    let tx = await pigeonAttack.attack(await setupPigeonSEETF23Contract.pigeon());
    await tx.wait();
    log(`Is solved: ${chalk.yellow(await setupPigeonSEETF23Contract.isSolved())}`);
    
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});