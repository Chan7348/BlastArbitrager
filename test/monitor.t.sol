// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;
import { Test, console} from "forge-std/Test.sol";
import { Monitor } from "contracts/Monitor.sol";

contract testMonitor is Test {
    Monitor monitor = new Monitor();

    function testPrice() public view {
        console.log("thrusterPrice:", monitor.thrusterETHPriceWithPower(0, true));
        console.log("ambientPrice: ", monitor.ambientETHPriceWithPower(0, false));
        (uint thrusterPrice, uint ambientPrice) = monitor.ETHpricesWithPower(0);
        console.log("two prices:", thrusterPrice, "\n", ambientPrice);
    }
}