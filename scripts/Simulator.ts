import { ethers } from "hardhat";

async function deploy() {
    const Simulator = await ethers.getContractFactory("Simulator");
    const simulator = await Simulator.deploy({gasLimit: 100_0000});
    console.log("Simulator deployed to:", await simulator.getAddress());

}

deploy().then(() => process.exit(0)).catch(error => {
    console.error(error);
    process.exit(1);
});