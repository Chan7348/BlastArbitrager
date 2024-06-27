// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;
// import { IQuoterV2 } from "contracts/interfaces/thruster/IQuoterV2.sol";
import { IQuoter } from "contracts/interfaces/thruster/IQuoter.sol";
import { ICrocImpact } from "contracts/interfaces/ambient/ICrocImpact.sol";
import { IERC20Metadata } from "@openzeppelin/contracts/interfaces/IERC20Metadata.sol";
import { PriceConvert } from "contracts/libraries/PriceConvert.sol";
contract Simulator {
    // address quoterAddr = 0x3b299f65b47c0bfAEFf715Bc73077ba7A0a685bE; // thruster
    address quoterAddr = 0x9D0F15f2cf58655fDDcD1EE6129C547fDaeD01b1; // uni 
    IQuoter quoter;

    // blast USDB
    // address USDBaddr = 0x4300000000000000000000000000000000000003;
    // IERC20Metadata USDB;

    // blast WETH
    // address WETHaddr = 0x4300000000000000000000000000000000000004;
    // IERC20Metadata WETH;

    // address thruster_WETH_USDB_V3_500 = 0x7f0DB0D77d0694F29c3f940b5B1F589FFf6EF2e0;

    address crocImpactAddr = 0x6A699AB45ADce02891E6115b81Dfb46CAa5efDb9;
    ICrocImpact crocImpact;
    constructor() {
        quoter = IQuoter(quoterAddr);
        crocImpact = ICrocImpact(crocImpactAddr);
        // USDB = IERC20Metadata(USDBaddr);
        // WETH = IERC20Metadata(WETHaddr);
    }

    function quoteThruster(address WETHaddr, address USDBaddr, address pool, bool buyETH, bool exactInput, uint256 amount, uint128 power) public view 
        returns (uint256 amountReturn, uint160 price, uint32 initializedTicksCrossed, uint256 gasEstimate) {
        // uint256 amountReturn;
        // uint160 sqrtPriceX96After;
        // uint32 initializedTicksCrossed;
        // uint256 gasEstimate;

        if (exactInput) { 
            (amountReturn, price, initializedTicksCrossed, gasEstimate) = quoter.quoteExactInputSingleWithPool(IQuoter.QuoteExactInputSingleWithPoolParams({
                tokenIn: buyETH ? USDBaddr : WETHaddr,
                tokenOut: buyETH ? WETHaddr : USDBaddr,
                amountIn: amount,
                pool: pool,
                fee: 500,
                sqrtPriceLimitX96: 0
            }));
            price = uint160(PriceConvert.getPriceFromSqrtPriceX96(price, power, false));
            // return (amountReturn, price, initializedTicksCrossed, gasEstimate);
        } else {
            (amountReturn, price, initializedTicksCrossed, gasEstimate) = quoter.quoteExactOutputSingleWithPool(IQuoter.QuoteExactOutputSingleWithPoolParams({
                tokenIn: buyETH ? USDBaddr : WETHaddr,
                tokenOut: buyETH ? WETHaddr : USDBaddr,
                amount: amount,
                pool: pool,
                fee: 500,
                sqrtPriceLimitX96: 0
            }));
            price = uint160(PriceConvert.getPriceFromSqrtPriceX96(price, power, false));
            // return (amountReturn, price, initializedTicksCrossed, gasEstimate);
        }
    }

    function quoteAmbient(address ETHaddr, address USDBaddr, bool buyETH, bool isInUSDBQty, uint128 quantity, uint128 power) public view 
        returns (int128 baseFlow, int128 quoteFlow, uint128 finalPrice) {
        (baseFlow, quoteFlow, finalPrice) = crocImpact.calcImpact(
            ETHaddr, 
            USDBaddr, 
            420, // 池索引，固定
            !buyETH, // True，用户支付ETH并接收USDB。 False，用户支付USDB并接收ETH
            !isInUSDBQty, // True，用ETH计量。False，用USDB计量
            quantity, // token数量
            0, // 为零时接受标准费率。不为零时为可容忍的最高费率
            buyETH ? uint128(0) : type(uint128).max // 最差价格
            );
        finalPrice = uint128(PriceConvert.Q64_64ToPriceWithPower(finalPrice, false, power));
    }
}