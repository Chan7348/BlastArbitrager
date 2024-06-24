// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

interface ICrocImpact {
    function calcImpact(address base, address quote,
                        uint256 poolIdx, bool isBuy, bool inBaseQty, uint128 qty,
                        uint16 poolTip, uint128 limitPrice) external view  
        returns (int128 baseFlow, int128 quoteFlow, uint128 finalPrice);
}

// blast 0x6A699AB45ADce02891E6115b81Dfb46CAa5efDb9