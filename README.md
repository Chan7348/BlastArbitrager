## 主要工作：



### Monitor合约+测试合约+配套ts脚本

#### PriceConvert库：
将Q64_64价格 or Q64_96价格 转换为token0或者token1的价格，其中power为放大的次数，也即decimals

#### 注意事项：
   thruster中WETH为token1
   而ambient中baseToken即token0为ETH，地址为address(0)

thruster有两个V3pool深度比较好，费率为0.3%和0.05%，这里选择深度更好且手续费低的0.05%池子
ambient手续费为合约动态调整，不能手动设置，但是可以设置tip，表示用户愿意向LP提供的手续费上限




### Simulator合约+测试合约
   主要封装了两边池子的模拟swap过程，用以计算将会支付/接收的token数量
   ambient -> 项目方已经封装好了view函数可以直接用
   thruster -> 项目方没能封装好view函数，选择使用uniswap封装的quoter合约


### 套利过程：《第一版》


#### 大致过程 监控阈值 -> 超过阈值触发tx -> 循环计算套利空间 -> 执行swap -> 亏钱检查 -> 结束套利


#### Monitor脚本监测到价格差价超过阈值0.15%，启动套利tx:

##### ETH thruster更便宜的情况：
   1. 进入模拟循环，计算(试探)套利空间
      1. 设置初始的 ETHOutAmount(这是对于thruster这笔swap来说的)和步长stepSize
      2. 计算从thruster(便宜一方)买到{ ETHOutAmount }个ETH需要给他多少U(闪电兑换的欠款) -> Uamount1
      3. 计算将买到的ETH{ ETHOutAmount }全卖给ambient(贵一方)会得到多少U -> Uamount2
         情况A: 如果 Uamount2 - Uamount1 > gas，我们就有套利空间，这个ETHOutAmount是合适的 -> 下一个循环尝试更大的ETHOutAmount
         情况B: 如果 Uamount2 - Uamount1 < gas，没有套利空间，返回上一次循环 or 直接revert
   
   2. 计算出比较合适的ETHOutAmount之后，执行两侧的swap，最后检查时只要不亏钱就放行，完成套利，赚U


##### ETH thruster更贵的情况:
   1. 进入模拟循环，计算(试探)套利空间
      1. 设置初始的 USDBOutAmount(这是对于thruster这笔swap来说的)和步长stepSize
      2. 计算从thruster(贵一方)拿到{USDBOutAmount} 需要卖的ETH数量(闪电兑换的欠款) -> Eamount1
      3. 计算将得来的USDB全给ambient(便宜一方)能买到多少ETH -> Eamount2
         情况A: 如果Eamount2 - Eamount1 > gas，有套利空间，这个USDBOutAmount是合适的 -> 下一个循环尝试更大的USDBOutAmount
         情况B: 如果Eamount2 - Eamount1 < gas, 没有套利空间，返回上一次循环 or 直接revert
   2. 计算得到合适的USDBoutAmount之后，执行两侧的swap，最后检查时只要不亏钱就放行，完成套利，赚E



#### 纸上谈兵时
逻辑比较多的地方在于 套利空间计算方法的设计
写代码的过程中可能swap的过程逻辑会更多一些

#### 关于资金:
感觉不需要本金，应该只用闪电兑换就可以了，手续费的部分在循环中会进行计算，cover不掉就会全部revert -> (设置的参数USDBOutAmount/ETHOutAmount/stepSize不合理需要调整，可以用Tenderly来review错误tx的细节以更新参数)

