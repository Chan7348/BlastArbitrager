// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

interface ICrocSwapDex {
    function userCmd (uint16 callpath, bytes calldata cmd) external payable returns (bytes memory);
    function swap (address base, address quote, uint256 poolIdx, bool isBuy, bool inBaseQty, uint128 qty, uint16 tip, uint128 limitPrice, uint128 minOut, uint8 reserveFlags) external payable returns (int128 baseFlow, int128 quoteFlow);
}

// blast 0xaAaaaAAAFfe404EE9433EEf0094b6382D81fb958