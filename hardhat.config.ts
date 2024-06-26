import { HardhatUserConfig, vars } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "@nomicfoundation/hardhat-foundry";
import "@nomicfoundation/hardhat-verify";
const config: HardhatUserConfig = {
  solidity: {
    version: "0.8.24",
    settings: {
      evmVersion: "cancun",
      optimizer: {
        enabled: true,
        runs: 1000,
      },
    },
  },
  defaultNetwork: 'localhost',
  networks: {
    hardhat: {
      forking: {
        // url: "https://eth-mainnet.g.alchemy.com/v2/0bxYCEMVua9fTrQ8ZdjLmtneFjjI2HI_" || "", // ethereum
        url: "https://blast-mainnet.infura.io/v3/9bffae8e7424498db9d2c180201a9b95" || "", // blast
        // blockNumber: 5023190,
      },
      blockGasLimit: 60000000,
      // hardfork: "cancun",
    },
    ethereum: {
      url: "https://eth-mainnet.g.alchemy.com/v2/0bxYCEMVua9fTrQ8ZdjLmtneFjjI2HI_" || "",
      accounts: [vars.get("TEST1_KEY"), vars.get("TEST2_KEY")],
    },
    sepolia: {
      url: "https://eth-sepolia.g.alchemy.com/v2/7dg61Re-J49kkBk9urxJIBwCRaVQcWq8" || "",
      accounts: [vars.get("TEST1_KEY"), vars.get("TEST2_KEY")],
    },
    arbitrum: {
      url: "https://arb-mainnet.g.alchemy.com/v2/3xJE5XydRW9R6svaRlbiXeyhVEm6yFFQ" || "",
      accounts: [vars.get("TEST1_KEY"), vars.get("TEST2_KEY")],
    },
    optimism: {
      url: "https://opt-mainnet.g.alchemy.com/v2/C0rnovoXZQ6eo9Egfvw1sTfkdLGsvouh" || "",
      accounts: [vars.get("TEST1_KEY"), vars.get("TEST2_KEY")],
    },
    base: {
      url: "https://base-mainnet.g.alchemy.com/v2/TGwFWGfUH96rmhISEJYNY1o1kTvqYasp" || "",
      accounts: [vars.get("TEST1_KEY"), vars.get("TEST2_KEY")],
    },
    blast: {
      url: "https://blast-mainnet.infura.io/v3/9bffae8e7424498db9d2c180201a9b95" || "",
      accounts: [vars.get("TEST1_KEY"), vars.get("TEST2_KEY")],
    },
    blastSepolia: {
      url: "https://blast-sepolia.infura.io/v3/9bffae8e7424498db9d2c180201a9b95" || "",
      accounts: [vars.get("TEST1_KEY"), vars.get("TEST2_KEY")],
    }
  },
  sourcify: {
    enabled: true,
  },
  etherscan: {
    apiKey: {
      arbitrumSepolia: 'IQWAAF48I9BVSMJA8BIVEGM8Z55DZXTBSD',
      sepolia: 'VK61M4154HUEBDRPEUZXF3MW2J7GSK9WJW',
      optimisticEthereum: '79WNIY53FCZY116W61ZN8DDTE1THBBVKN7',
      base: 'TJY2CHMTQMI1HF4WVQJES2CDVF4K733CUK',
      blast : 'DSSX24X9RC6YEA2FVQBJ8DK79YGZXGWG43'
    },
    customChains: [
      {
        network: "blast",
        chainId: 81457,
        urls: {
          apiURL: "https://api.routescan.io/v2/network/mainnet/evm/81457/etherscan",
          browserURL: "https://blastexplorer.io"
        }
      }
    ]
  },
  // dodoc: {
  //   runOnCompile: true,
  //   debugMode: false,
  // }
};

export default config;

