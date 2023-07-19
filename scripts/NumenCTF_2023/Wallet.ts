import chalk from "chalk";
import { ethers } from "hardhat";
import { WalletNumen23__factory, WalletNumen23, WalletNumen23Attack__factory } from "../../typechain";
import { log, initialize } from "../utils";

async function main() {
    let [walletNumen23Contract, attacker] = await initialize<WalletNumen23>(WalletNumen23__factory);

    const walletNumen23Attack = await new WalletNumen23Attack__factory(attacker).deploy();
    await walletNumen23Attack.waitForDeployment();
    let tx = await walletNumen23Attack.attack(await walletNumen23Contract.getAddress());
    await tx.wait();
    log(`Is solved: ${chalk.yellow(await walletNumen23Contract.isSolved())}`);

}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});