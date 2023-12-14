import { ethers } from "ethers";

async function main() {
    // get initial fund
    let signature = ethers.Signature.from("0x1337C0DEC0DEC0DEC0DEC0DEC0DEC0DEC0DEC0DEC0DEC0DEC0DEC0DEC0DE13371337C0DEC0DEC0DEC0DEC0DEC0DEC0DEC0DEC0DEC0DEC0DEC0DEC0DEC0DE133728");
    console.log(signature.compactSerialized);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
})