// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

interface IQuoterV2 {
    struct QuoteExactInputSingleParams {
        address tokenIn;
        address tokenOut;
        uint256 amountIn;
        uint24 fee;
        uint160 sqrtPriceLimitX96;
    }
    struct QuoteExactOutputSingleParams {
        address tokenIn;
        address tokenOut;
        uint256 amount;
        uint24 fee;
        uint160 sqrtPriceLimitX96;
    }
    function quoteExactInputSingle(QuoteExactInputSingleParams memory params) external view returns (uint256 amountOut, uint160 sqrtPriceX96After, uint32 initializedTicksCrossed, uint256 gasEstimate);
    function quoteExactInput(bytes memory path, uint256 amountIn) external view returns (uint256 amountOut, uint160[] memory sqrtPriceX96AfterList, uint256 gasEstimate);
    function quoteExactOutputSingle(QuoteExactOutputSingleParams memory params) external view returns (uint256 amountIn, uint160 sqrtPriceX96After, uint32 initializedTicksCrossed, uint256 gasEstimate);
    function quoteExactOutput(bytes memory path, uint256 amountOUt) external returns (uint256 amountIn, uint160[] memory sqrtPriceX96AfterList, uint32[] memory initializedTicksCrossedList, uint256 gasEstimate);

}

// blast 0x3b299f65b47c0bfAEFf715Bc73077ba7A0a685bE