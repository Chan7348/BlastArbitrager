// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;
import { IThrusterPool } from "contracts/interfaces/thruster/IThrusterPool.sol";
import { IERC20Metadata } from "@openzeppelin/contracts/interfaces/IERC20Metadata.sol";
contract Moniter {
    IThrusterPool thrusterPool = IThrusterPool(0xf00DA13d2960Cf113edCef6e3f30D92E52906537);
    IERC20Metadata USDC = IERC20Metadata(0x4300000000000000000000000000000000000003);
    IERC20Metadata WETH = IERC20Metadata(0x4300000000000000000000000000000000000004);

    function getThrusterPoolPrice() view public returns (uint160 sqrtPrice) {
        (sqrtPrice, , , , , ,) = thrusterPool.slot0();
    }
    
}