// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;
import { Test, console} from "forge-std/Test.sol";
import { Monitor } from "contracts/Monitor.sol";

contract testMonitor is Test {
    Monitor monitor = new Monitor();

    function testPrice() public view {
        uint16 power = 18;
        (uint thrusterPrice, uint thrusterNumber) = monitor.thrusterETHPriceWithPower(power, true);
        (uint ambientPrice, uint ambientNumber) = monitor.ambientETHPriceWithPower(power, false);
        console.log("thrusterPrice:", thrusterPrice, "at:", thrusterNumber);
        console.log("ambientPrice: ", ambientPrice, "at:", ambientNumber);
        (uint thrusterPrice1, uint ambientPrice1, uint blockNum) = monitor.ETHpricesWithPower(power);
        console.log("two prices at:", blockNum, thrusterPrice1, ambientPrice1);
    }
}