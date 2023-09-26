import chalk from "chalk";
import { ethers } from "hardhat";
import { ByteDanceMetaTrust23__factory, ByteDanceMetaTrust23, ByteDanceAttackMetaTrust23__factory} from "../../typechain";
import { log, initialize } from "../utils";

function isPalindrome(str: string): boolean {
    return str === str.split('').reverse().join('');
}

function getAllPalindromicBytes(): string[] {
    let result: string[] = [];

    for (let i = 0; i <= 255; i++) { // 遍历从0到255的所有字节
        let binaryString = i.toString(2).padStart(8, '0');
        if (isPalindrome(binaryString)) {
            let hexString = i.toString(16).toUpperCase().padStart(2, '0');
            if (i%2==1) {
                result.push(hexString);
            }
        }
    }
    return result;
}

async function main() {
    // console.log(getAllPalindromicBytes());
    let [byteDanceContract, attacker] = await initialize<ByteDanceMetaTrust23>(ByteDanceMetaTrust23__factory);
    let attackContract = await new ByteDanceAttackMetaTrust23__factory(attacker).deploy();
    await attackContract.waitForDeployment();
    // console.log(await ethers.provider.getCode(await attackContract.getAddress()));
    let tx = await byteDanceContract.checkCode(await attackContract.getAddress());
    await tx.wait();

    log(`Is solved: ${chalk.yellow(await byteDanceContract.isSolved())}`);

}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});