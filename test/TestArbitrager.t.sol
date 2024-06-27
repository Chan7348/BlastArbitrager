// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;
import { Test, console } from "forge-std/Test.sol";
import { Arbitrager } from "contracts/Arbitrager.sol";

contract TestArbitrager is Test {
    address crocSwapDexAddr = 0xaAaaaAAAFfe404EE9433EEf0094b6382D81fb958;
    address WETHaddr = 0x4300000000000000000000000000000000000004;
    address USDBaddr = 0x4300000000000000000000000000000000000003;
    address thruster_WETH_USDB_V3_500 = 0x7f0DB0D77d0694F29c3f940b5B1F589FFf6EF2e0;
    Arbitrager arbitrager;
    
    constructor() {
        arbitrager = new Arbitrager(address(this));
    }

    // function testInit() public {
    //     console.log("arbitrager owner:", arbitrager.owner());
    //     console.log("msg.sender:", msg.sender);
    //     console.log("address(this)", address(this));
    // }

    function testArbitrageUSDB() public {
        arbitrager.arbitrageUSDB(thruster_WETH_USDB_V3_500, 1e7, 5e14);
    }
}