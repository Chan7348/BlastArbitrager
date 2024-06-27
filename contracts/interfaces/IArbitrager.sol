// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

interface IArbitrager {
    function arbitrageUSDB(address thrusterPool, uint256 WETHOutAmount, uint256 stepSize) external;
    function arbitrageETH(uint256 USDBOutAmount, uint256 stepSize) external;
}