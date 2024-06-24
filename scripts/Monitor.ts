import { TypedContractMethod } from './../typechain-types/common';
import { ethers } from "hardhat";

// async function deploy() {
//     const Monitor = await ethers.getContractFactory("Monitor");
//     const monitor = await Monitor.deploy({gasLimit: 100_0000});
//     console.log("Monitor deployed to:", await monitor.getAddress());

// }

// deploy().then(() => process.exit(0)).catch(error => {
//     console.error(error);
//     process.exit(1);
// });

async function main() {
    const Monitor = await ethers.getContractAt("Monitor", "0xe472C1a46B9AA4Dc3c2d1e5C28E78128305092c1");
    const power = 4;
    const [thrusterPriceInBigNumber, ambientPriceInBigNumber, blockNum]= await Monitor.ETHpricesWithPower(power);
    const thrusterPrice = ethers.toNumber(thrusterPriceInBigNumber) / 10 ** power;
    const ambientPrice = ethers.toNumber(ambientPriceInBigNumber) / 10 ** power;
    console.log("blockNumber:", blockNum.toString());
    console.log("thrusterPrice:", thrusterPrice);
    console.log("ambientPrice: ", ambientPrice);
    const difference = thrusterPrice > ambientPrice ? thrusterPrice - ambientPrice : ambientPrice - thrusterPrice;
    const differencePercentage = (difference * 100 / (thrusterPrice > ambientPrice ? ambientPrice : thrusterPrice)).toFixed(6) + "%";
    // const differencePercentage = (ethers.toNumber(difference)  * 100 / ethers.toNumber(thrusterPrice > ambientPrice ? ambientPrice : thrusterPrice));

    console.log("difference:", difference);
    console.log("differencePercentage:", differencePercentage);
    console.log("--------------------------------");

    // thruster500pool L 7596154 600091497988239201 price 3509
    // USDB 2453w 7858           869464870963990587
    // WETH 1w    1574           997404075779398794
    // ambient L         2255761 067976965200210393 price 3510
}

setInterval(async () => {
    try {
        await main();
    } catch (error) {
        console.error(error);
    }
}, 2000); // 每2秒执行一次
