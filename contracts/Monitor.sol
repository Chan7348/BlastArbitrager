// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;
import { IThrusterPool } from "contracts/interfaces/thruster/IThrusterPool.sol";
import { IERC20Metadata } from "@openzeppelin/contracts/interfaces/IERC20Metadata.sol";
import { ICrocQuery } from "contracts/interfaces/ambient/ICrocQuery.sol";
// import { console } from "forge-std/console.sol";
import { Math } from "@openzeppelin/contracts/utils/math/Math.sol";

contract Monitor {
    
    

    address thrusterPoolFactory = 0x71b08f13B3c3aF35aAdEb3949AFEb1ded1016127;

    // blast Thruster WETH_USDB_V3_0.3% 深度差
    address thruster_WETH_USDB_V3_3000 = 0xf00DA13d2960Cf113edCef6e3f30D92E52906537;
    IThrusterPool thrusterPool3000;

    // blast Thruster WETH_USDB_V3_0.05% 深度好
    address thruster_WETH_USDB_V3_500 = 0x7f0DB0D77d0694F29c3f940b5B1F589FFf6EF2e0;
    IThrusterPool thrusterPool500;

    // blast USDB
    address USDBaddr = 0x4300000000000000000000000000000000000003;
    IERC20Metadata USDB;

    // blast WETH
    address WETHaddr = 0x4300000000000000000000000000000000000004;
    IERC20Metadata WETH;

    // blast ezETH
    address ezETHaddr = 0x2416092f143378750bb29b79eD961ab195CcEea5;
    IERC20Metadata ezETH;
    
    address crocQueryAddr = 0xA3BD3bE19012De72190c885FB270beb93e36a8A7;
    ICrocQuery crocQuery;

    constructor() {
        USDB = IERC20Metadata(USDBaddr);
        WETH = IERC20Metadata(WETHaddr);
        ezETH = IERC20Metadata(ezETHaddr);
        thrusterPool3000 = IThrusterPool(thruster_WETH_USDB_V3_3000);
        thrusterPool500 = IThrusterPool(thruster_WETH_USDB_V3_500);
        crocQuery = ICrocQuery(crocQueryAddr);
    }

    function thrusterETHPriceWithPower(uint160 power, bool isToken1) view public returns (uint256 price) {
        (uint160 sqrtPriceX96, , , , , ,) = thrusterPool500.slot0();
        price = _getPriceFromSqrtPriceX96(sqrtPriceX96, uint128(10 ** power), !isToken1);
        // console.log("Decimals of token0 USDB:", USDB.decimals());
        // console.log("Decimals of token1 WETH:", WETH.decimals());
    }
    function ambientETHPriceWithPower(uint power, bool isQuoteToken) view public returns (uint256 price) {
        price = _Q64_64ToPriceWithPower(crocQuery.queryPrice(address(0), address(USDB), 420), isQuoteToken, power);
    }
    function ETHpricesWithPower(uint160 power) view public returns (uint256 thrusterPrice, uint256 ambientPrice) {
        thrusterPrice = thrusterETHPriceWithPower(power, true);
        ambientPrice = ambientETHPriceWithPower(power, false);
    }

    function _Q64_64ToPriceWithPower(uint128 q64_64, bool isQuoteToken, uint power) private pure returns (uint256 price) {
        require(power % 2 ==0, "power must be even");
        // 将 Q64.64 转换为实际价格
        if (isQuoteToken) {
            uint256 price0 = (uint256(q64_64)) * ((10 ** (power / 2))) / 2 ** 64;
            price = price0 * price0;
        } else {
            uint256 price0 = (2 ** 64) * ((10 ** (power / 2))) / (uint256(q64_64));
            price = price0 * price0;
        }
    }
    // sqrt价格转化为普通价格，精度为baseAmount
    function _getQuoteFromSqrtRatioX96(uint160 sqrtRatioX96, uint128 baseAmount, bool inverse) private pure returns (uint256 quoteAmount) {
        // Calculate quoteAmount with better precision if it doesn't overflow when multiplied by itself
        if (sqrtRatioX96 <= type(uint128).max) {
            uint256 ratioX192 = uint256(sqrtRatioX96) * sqrtRatioX96;
            quoteAmount = !inverse
                ? Math.mulDiv(ratioX192, baseAmount, 1 << 192)
                // ? (ratioX192 * baseAmount) / (1 << 192);
                : Math.mulDiv(1 << 192, baseAmount, ratioX192);
        } else {
            uint256 ratioX128 = Math.mulDiv(
                sqrtRatioX96,
                sqrtRatioX96,
                1 << 64
            );
            quoteAmount = !inverse
                ? Math.mulDiv(ratioX128, baseAmount, 1 << 128)
                : Math.mulDiv(1 << 128, baseAmount, ratioX128);
        }
    }
    function _getPriceFromSqrtPriceX96(uint160 sqrtPriceX96, uint128 base, bool istoken0) private pure returns (uint256 priceU18) {
        return _getQuoteFromSqrtRatioX96(sqrtPriceX96, base, !istoken0);
    }
}