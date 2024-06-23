import { ethers } from "hardhat";

async function main() {
    const Monitor = await ethers.getContractAt("Monitor", "0x3B5e737444e81DbEae48d24948e77527f3e5e3C0");
    const power = 12;
    const [thrusterPriceInBigNumber, ambientPriceInBigNumber]= await Monitor.ETHpricesWithPower(power);
    const thrusterPrice = ethers.toNumber(thrusterPriceInBigNumber) / 10 ** power;
    const ambientPrice = ethers.toNumber(ambientPriceInBigNumber) / 10 ** power;
    console.log("thrusterPrice:", thrusterPrice);
    console.log("ambientPrice: ", ambientPrice);
    const difference = thrusterPrice > ambientPrice ? thrusterPrice - ambientPrice : ambientPrice - thrusterPrice;
    const differencePercentage = (difference * 100 / (thrusterPrice > ambientPrice ? ambientPrice : thrusterPrice)).toFixed(6) + "%";
    // const differencePercentage = (ethers.toNumber(difference)  * 100 / ethers.toNumber(thrusterPrice > ambientPrice ? ambientPrice : thrusterPrice));

    console.log("difference:", difference);
    console.log("differencePercentage:", differencePercentage);

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
