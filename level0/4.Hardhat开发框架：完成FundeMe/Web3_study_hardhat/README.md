# Sample Hardhat Project

This project demonstrates a basic Hardhat use case. It comes with a sample contract, a test for that contract, and a Hardhat Ignition module that deploys that contract.

Try running some of the following tasks:

```shell
npx hardhat help
npx hardhat test
REPORT_GAS=true npx hardhat test
npx hardhat node
npx hardhat ignition deploy ./ignition/modules/Lock.js
```

hardhat.config.js 是 Hardhat 项目的配置文件
contracts文件夹 用于存放合约
ignition文件夹 用于管理 Hardhat Ignition 的部署模块和配置。它是hardhat自己创建的一套部署和调用合约的一个机制。(官网有详细的讲解)
https://hardhat.org/ignition/docs/getting-started#overview
test文件夹 用于存放用于测试contracts文件夹中合约的文件

编译合约指令：npx hardhat compile   
    在 Hardhat 项目中编译合约
    https://hardhat.org/hardhat-runner/docs/guides/compile-contracts(官网地址)
会多出2个文件夹
    artifacts --存储编译信息和引入过的合约
    cache --存储编译时间，编译时的配置，以后部署的信息

部署合约: