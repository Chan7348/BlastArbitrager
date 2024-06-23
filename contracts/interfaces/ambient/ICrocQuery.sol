// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

interface ICrocQuery {
    function queryCurve(address base, address quote, uint256 poolIdx) external view;
    function queryPrice(address base, address quote, uint256 poolIdx) external view returns (uint128);
}

// blast 0xA3BD3bE19012De72190c885FB270beb93e36a8A7