// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;
import { Math } from "@openzeppelin/contracts/utils/math/Math.sol";

library PriceConvert {
    function Q64_64ToPriceWithPower(uint128 q64_64, bool isQuoteToken, uint power) internal pure returns (uint256 price) {
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
    
    function getPriceFromSqrtPriceX96(uint160 sqrtPriceX96, uint128 power, bool istoken0) internal pure returns (uint256 priceU18) {
        return _getQuoteFromSqrtRatioX96(sqrtPriceX96, uint128(10 ** power), !istoken0);
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
}