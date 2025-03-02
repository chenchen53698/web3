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

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.28",
};
