// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

interface ISimulator {
    function quoteThruster(address WETHaddr, address USDBaddr, address pool, bool buyETH, bool exactInput, uint256 amount, uint128 power) external view 
        returns (uint256 amountReturn, uint160 price, uint32 initializedTicksCrossed, uint256 gasEstimate);

    function quoteAmbient(address ETHaddr, address USDBaddr, bool buyETH, bool isInUSDBQty, uint128 quantity, uint128 power) external view 
        returns (int128 baseFlow, int128 quoteFlow, uint128 finalPrice);
}