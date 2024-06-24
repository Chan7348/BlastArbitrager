// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import { Test, console} from "forge-std/Test.sol";
import { Simulator } from "contracts/Simulator.sol";

contract TestSimulator is Test {
    Simulator simulator = new Simulator();

    function testThruster() public view {
        (uint256 amountOut, uint256 price, uint32 initializedTicksCrossed, uint256 gasEstimate) = 
        simulator.quoteThruster(true, true, 333 * 1e18);
        console.log("ETHout:", amountOut);
        console.log("price with power:", price, 8);
        console.log("tick crossed:", initializedTicksCrossed);
        console.log("gas:", gasEstimate);
    }

    function testAmbient() public view {
        uint128 amount = 3000;
        (int128 ethAmount, int128 usdbAmount, uint128 finalPrice) = 
        simulator.quoteAmbient(
            true, // 是否买ETH
            false, // 是否以USDB计量
            amount * 1e18 // 计价数量
        );
        console.log("sell ETH amount", amount);
        if (ethAmount >= 0) {
            uint eth = uint128(ethAmount);
            console.log("ETH payed to pool amount:    ", eth);
        } else {
            uint128 eth = uint128(-ethAmount);
            console.log("ETH received from pool:   ", eth);
        }

        if (usdbAmount >= 0) {
            uint usdb = uint128(usdbAmount);
            console.log("USDB payed to pool amount:", usdb);
        } else {
            uint128 usdb = uint128(-usdbAmount);
            console.log("USDB received from pool amount:  ", usdb);
        }
        console.log("finalPrice:", finalPrice);
    }
}