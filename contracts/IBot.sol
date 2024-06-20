// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

interface IBot {
    // 这个size返回我们的本金，计算出我们最多可以使用多少baseToken进行套利，如果是闪电贷的话，则是我们需要向低价池子借出的baseToken的数量
    function calculateSize() external view;
    function arbitrage() external;
    
}