// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;
import { IThrusterPool } from "contracts/interfaces/thruster/IThrusterPool.sol";
import { IERC20Metadata } from "@openzeppelin/contracts/interfaces/IERC20Metadata.sol";
import { ICrocQuery } from "contracts/interfaces/ambient/ICrocQuery.sol";
// import { console } from "forge-std/console.sol";
// import { Math } from "@openzeppelin/contracts/utils/math/Math.sol";
import { PriceConvert } from "contracts/libraries/PriceConvert.sol";

contract Monitor {
    
    

    address thrusterPoolFactory = 0x71b08f13B3c3aF35aAdEb3949AFEb1ded1016127;

    // blast Thruster WETH_USDB_V3_0.3% 深度差
    // address thruster_WETH_USDB_V3_3000 = 0xf00DA13d2960Cf113edCef6e3f30D92E52906537;
    // IThrusterPool thrusterPool3000;

    // blast Thruster WETH_USDB_V3_0.05% 深度好
    address thruster_WETH_USDB_V3_500 = 0x7f0DB0D77d0694F29c3f940b5B1F589FFf6EF2e0;
    IThrusterPool thrusterPool500;

    // blast USDB
    address USDBaddr = 0x4300000000000000000000000000000000000003;
    IERC20Metadata USDB;

    // blast WETH
    address WETHaddr = 0x4300000000000000000000000000000000000004;
    IERC20Metadata WETH;
    
    address crocQueryAddr = 0xA3BD3bE19012De72190c885FB270beb93e36a8A7;
    ICrocQuery crocQuery;

    constructor() {
        USDB = IERC20Metadata(USDBaddr);
        WETH = IERC20Metadata(WETHaddr);
        // ezETH = IERC20Metadata(ezETHaddr);
        // thrusterPool3000 = IThrusterPool(thruster_WETH_USDB_V3_3000);
        thrusterPool500 = IThrusterPool(thruster_WETH_USDB_V3_500);
        crocQuery = ICrocQuery(crocQueryAddr);
    }

    function thrusterETHPriceWithPower(uint128 power, bool isToken1) view public returns (uint256 price, uint256 blockNum) {
        (uint160 sqrtPriceX96, , , , , ,) = thrusterPool500.slot0();
        price = PriceConvert.getPriceFromSqrtPriceX96(sqrtPriceX96, power, !isToken1);
        blockNum = block.number;
        // console.log("Decimals of token0 USDB:", USDB.decimals());
        // console.log("Decimals of token1 WETH:", WETH.decimals());
    }
    function ambientETHPriceWithPower(uint power, bool isQuoteToken) view public returns (uint256 price, uint256 blockNum) {
        price = PriceConvert.Q64_64ToPriceWithPower(crocQuery.queryPrice(address(0), address(USDB), 420), isQuoteToken, power);
        blockNum = block.number;
    }
    function ETHpricesWithPower(uint128 power) view public returns (uint256 thrusterPrice, uint256 ambientPrice, uint256 blockNum) {
        (thrusterPrice, ) = thrusterETHPriceWithPower(power, true);
        (ambientPrice, ) = ambientETHPriceWithPower(power, false);
        blockNum = block.number;
    }
}