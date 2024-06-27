// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;
import { IArbitrager } from "contracts/interfaces/IArbitrager.sol";
import { PriceConvert } from "contracts/libraries/PriceConvert.sol";
import { Simulator } from "contracts/Simulator.sol";
import { IThrusterPoolActions } from "contracts/interfaces/thruster/pool/IThrusterPoolActions.sol";
import { ICrocSwapDex } from "contracts/interfaces/ambient/ICrocSwapDex.sol";
import { IWETH } from "contracts/interfaces/IWETH.sol";
import { IERC20Metadata } from "@openzeppelin/contracts/interfaces/IERC20Metadata.sol";
import { console } from "forge-std/Test.sol";
import { Strings } from "@openzeppelin/contracts/utils/Strings.sol";
contract Arbitrager is IArbitrager, Simulator {
    address crocSwapDexAddr = 0xaAaaaAAAFfe404EE9433EEf0094b6382D81fb958;
    address thrusterPool = 0x7f0DB0D77d0694F29c3f940b5B1F589FFf6EF2e0;
    address WETHaddr = 0x4300000000000000000000000000000000000004;
    address USDBaddr = 0x4300000000000000000000000000000000000003;
    address public owner;
    constructor (address _owner) {
        owner = _owner;
    }   
    // thruster便宜的情况,在thruster买ETH，在ambient卖出
    struct ArbitrageUSDBTemp {
        uint256 WETHOutAmountTemp;
        uint256 WETHOutAmountTempLast;
        uint16 count;
    }
    struct FlashSwapCallbackData {
        address tokenIn;
        address tokenOut;
        uint256 amount;
        address payer;
        address pool;
        // uint256 amountOwedThruster;
    }
    function arbitrageUSDB(uint256 WETHBoughtFromThruster, uint256 stepSize) external {
        // address WETHaddr = 0x4300000000000000000000000000000000000004;
        // address USDBaddr = 0x4300000000000000000000000000000000000003;
        // address ETHaddr = address(0);
        // address thruster_WETH_USDB_V3_500 = 0x7f0DB0D77d0694F29c3f940b5B1F589FFf6EF2e0;

        // 计算价格impact
        // ArbitrageUSDBTemp memory temp = ArbitrageUSDBTemp({
        //     WETHOutAmountTemp: WETHOutAmount,
        //     WETHOutAmountTempLast: 0,
        //     count: 0
        // });
        // uint256 owed;
        // while (true) {
        //     (uint256 uAmount1, , ,) = quoteThruster(
        //         WETHaddr,
        //         USDBaddr,
        //         thrusterPool,
        //         true, // buyETH
        //         false, // exactInput
        //         temp.WETHOutAmountTemp, // amount
        //         12 // decimals of price
        //     );
        //     (, int128 USDBflow,) = quoteAmbient(
        //         address(0), 
        //         USDBaddr, 
        //         false, // buyETH
        //         false, // isInUSDBQty
        //         uint128(temp.WETHOutAmountTemp), // quantity
        //         12 // decimals
        //     );
        //     // bool greater = USDBflow >= 0;
        //     // console.log("greater:", greater);
        //     // console.log("get USDB from ambient:", USDBflow);
        //     // console.log("owed thruster:", uAmount1);
        //     int128 get = -(int128(int256(uAmount1)) + USDBflow);
        //     console.log("USDB owed to thruster:", uAmount1);
        //     console.log("USDB get from ambient:", uint128(USDBflow));
        //     console.log("get:              ", Strings.toStringSigned(get));
        //     console.log("WETHOutAmountTemp:", temp.WETHOutAmountTemp);
        //     console.log("WETHOutAmountTempLast:", temp.WETHOutAmountTempLast);
        //     console.log("count:", temp.count);
        //     if (get <= 5e15) {// 5e17,0.5u,
        //         if (temp.count == 0) revert("Do not have space");
        //         WETHOutAmount = temp.WETHOutAmountTempLast;
        //         owed = uAmount1;
        //         break;
        //     }
        //     if (get >= 1e17) {
        //         WETHOutAmount = temp.WETHOutAmountTemp;
        //         owed = uAmount1;
        //         break;
        //     }
        //     ++temp.count;
        //     temp.WETHOutAmountTempLast = temp.WETHOutAmountTemp;
        //     temp.WETHOutAmountTemp += stepSize;
        // }
        // uAmount1
        // 执行swap,拿到WETH
        // USDB -> WETH 0for1
        IThrusterPoolActions(thrusterPool).swap(
            address(this),
            true,
            -int(WETHBoughtFromThruster),
            4295128740,
            abi.encode(
                FlashSwapCallbackData({
                    tokenIn: USDBaddr,
                    tokenOut: WETHaddr,
                    amount: WETHBoughtFromThruster,
                    payer: msg.sender,
                    pool: thrusterPool
                    // amountOwedThruster: owed
                })
            )
        );
    }
    // thruster贵的情况，
    function arbitrageETH(uint256 USDBBoughtFromThruster, uint256 stepSize) external {
        IThrusterPoolActions(thrusterPool).swap(
            address(this),
            false,
            -int(USDBBoughtFromThruster),
            1461446703485210103287273052203988822378723970342, // MAX_RATIO
            abi.encode(
                FlashSwapCallbackData({
                    tokenIn: WETHaddr,
                    tokenOut: USDBaddr,
                    amount: USDBBoughtFromThruster,
                    payer: msg.sender,
                    pool: thrusterPool
                })
            )
        );
    }

    function uniswapV3SwapCallback(int256 amount0Delta, int256 amount1Delta, bytes calldata data) external {
        FlashSwapCallbackData memory decoded = abi.decode(data, (FlashSwapCallbackData));
        require(msg.sender == decoded.pool);
        if (decoded.tokenIn == USDBaddr) {
            // swap in ambient
            // 这种情况是从thruster拿出了WETH，需要先对其unwrap
            uint WETHBoughtFromThruster = uint256(-amount1Delta);
            uint USDBPaidToThruster = uint256(amount0Delta);
            uint actualPriceInThruster = (USDBPaidToThruster * 1e4) / WETHBoughtFromThruster;
            console.log("USDBPaidToThruster:", USDBPaidToThruster);
            console.log("WETHBoughtFromThruster", WETHBoughtFromThruster);
            console.log("actualPriceInThruster with decimals 4:", actualPriceInThruster);
            IWETH(WETHaddr).withdraw(uint256(WETHBoughtFromThruster));
            // delegatecall coldpath
            bytes memory output = ICrocSwapDex(crocSwapDexAddr).userCmd{value: WETHBoughtFromThruster}(1, abi.encode(
                address(0),
                USDBaddr,
                420, // pool idx
                true, // is buy the USDB
                true, // is in base quantity
                WETHBoughtFromThruster, // quantity
                500, // 是否有愿意支付的最高费率
                21267430153580247136652501917186561137, // 价格上限，这个值是最高的tick所对应的sqrtPrice
                0, // minOut
                0x0
            ));
            console.log("swap done!");
            // int128 getUSDB = abi.decode(output, (int128));
            // uint256 getUSDBUint = uint256(int256(-getUSDB));
            uint getUSDB = IERC20Metadata(USDBaddr).balanceOf(address(this));
            uint actualPriceInAmbient = (getUSDB * 1e4) / WETHBoughtFromThruster;
            console.log("USDB bought from ambient:", getUSDB);
            console.log("actualPriceInAmbient  with decimals 4:", actualPriceInAmbient);

            if (actualPriceInThruster < actualPriceInAmbient) console.log("price pass!!!!!!!!!!!");
            // hotpath
            // ICrocSwapDex(crocSwapDexAddr).swap(address(0),
            // address(USDB), 
            // 420, 
            // true, // isBuy USDB
            // true, // is inBaseQty 
            // ETHamount, 
            // 0, 
            // type(uint), 
            // uint128 minOut, 
            // uint8 reserveFlags);

            // uint USDBbalance = IERC20Metadata(USDBaddr).balanceOf(address(this));
            // console.log("reserve of USDB:", USDBbalance);

            IERC20Metadata(USDBaddr).transfer(msg.sender, uint(amount0Delta));
        } else if (decoded.tokenOut == WETHaddr) {
            uint USDBBoughtFromThruster = uint256(-amount0Delta);
            uint WETHPaidToThruster = uint256(amount1Delta);
            uint actualPriceInThruster = (USDBBoughtFromThruster * 1e4) / WETHPaidToThruster;
            bytes memory output = ICrocSwapDex(crocSwapDexAddr).userCmd(1, abi.encode(
                address(0),
                USDBaddr,
                420,
                false,
                false,
                USDBBoughtFromThruster,
                500,
                65538,
                type(uint).max,
                0x0
            ));

            IWETH(WETHaddr).deposit{value: WETHPaidToThruster}();
            IERC20Metadata(WETHaddr).transfer(msg.sender, WETHPaidToThruster);
        }
    }

    function collect() external {
        IERC20Metadata usdb = IERC20Metadata(USDBaddr);
        if (address(this).balance > 0) payable(owner).transfer(address(this).balance);
        if (usdb.balanceOf(address(this)) > 0) usdb.transfer(owner, usdb.balanceOf(address(this)));
    }

    receive() external payable {}
}