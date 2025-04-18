/*
  hardhat.config.js 是 Hardhat 项目的配置文件，
  用于定义项目的网络配置、插件、任务、编译器设置等。
  Hardhat 是一个以太坊开发环境，帮助开发者编译、测试和部署智能合约。 

  require("@nomicfoundation/hardhat-toolbox")：
    引入 Hardhat 工具箱插件，包含常用的插件和工具（如 @nomiclabs/hardhat-ethers、@nomiclabs/hardhat-waffle 等）。
  module.exports：
    导出一个配置对象，Hardhat 会根据该对象配置项目。
*/
require("@nomicfoundation/hardhat-toolbox");
require("@chainlink/env-enc").config();
require("./tasks");
require("hardhat-deploy");
require("@nomicfoundation/hardhat-ethers");
require("hardhat-deploy-ethers");
const SEPOLIA_URL = process.env.SEPOLIA_URL
const SEPOLIA_URL_1 = process.env.SEPOLIA_URL_1
const PRIVATE_KEY = process.env.PRIVATE_KEY
const PRIVATE_KEY_1 = process.env.PRIVATE_KEY_1
const ETHERSCAN_API_KEY = process.env.ETHERSCAN_API_KEY
/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  // defaultNetwork: "hardhat",  默认网络--本地测试网络
  solidity: "0.8.28",
  mocha: {
    timeout: 300000//测试超时时间
  },
  networks: {//网络配置
    //部署成功后，可以在https://sepolia.etherscan.io/上查看合约，但并不会像remix上一样弹出钱包，因为使用了他的私钥
    sepolia: {
      url: SEPOLIA_URL,
      accounts: [PRIVATE_KEY, PRIVATE_KEY_1],//部署时会默认使用 accounts 数组中的第一个私钥（即 PRIVATE_KEY）作为部署账户。如果你想使用其他私钥，需要在部署脚本中显式指定。
      chainId: 11155111
    }
  },
  etherscan: {//etherscan配置,用于验证合约
    apiKey: {
      sepolia: ETHERSCAN_API_KEY
    }
    // apiKey: ETHERSCAN_API_KEY
  },
  namedAccounts: {//命名账户
    // 获取networks-sepolia中accounts中下标为0,1的地址，以后可以直接使用firstAccount,secondAccount
    firstAccount: {
      default: 0
    },
    secondAccount: {
      default: 1
    }
  },
  gasReporter: {//gas报告
    enabled:false
  }
};
