import chalk from "chalk";
import { ethers } from "hardhat";
import { Challenge__factory, ChallengeAttack__factory } from "../../typechain";

// deployer: 0xAeDf5768271766Ab647f5F91533e9eFD86BBB350
// token: v4.local.usu5Bwu8MRZwn4Oaq2hqbtrpBbALMZC1HaTCE6MybkJA8vQGDudzdAiUi3wEhrfasPYIXkKmYRd9Gd8LYYGmV5a1vYpZBwPrxDKUR5PJDrioXFcM16T7m81Irne4Oi-ZI64inHqYsZiW-UekM8EMixm84sCt_Brc6o1V2RzQP9tDEw.U2V0dXA

function log(s:string){
    console.log(`${chalk.green("[-] ")+s}`)
}

function help(){
    // something helpful when solving but not used fanally
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

    let challengeContract;
    let tx;
    if(network.name == "hardhat") {
        challengeContract = await new Challenge__factory(deployer).deploy();
        await challengeContract.waitForDeployment();
        challengeContract = challengeContract.connect(attacker);
        log(`Successfully deployed the target contract to address ${chalk.yellow(await challengeContract.getAddress())}!`)
    } else if (network.name == "remote") {
        const contractAddress = "0x0000000000000000000000000000000000000000";
        challengeContract = Challenge__factory.connect(contractAddress, attacker);
        log(`Successfully connected to the target contract with address ${chalk.yellow(await challengeContract.getAddress())}!`)
    }
    // help();

    if(challengeContract) {
        const challengeAttack = await new ChallengeAttack__factory(attacker).deploy();
        await challengeAttack.waitForDeployment();

        // log(``);
    }


}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});