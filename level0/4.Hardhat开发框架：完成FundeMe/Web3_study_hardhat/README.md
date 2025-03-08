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
    写在scripts中
.env文件 用于存放敏感信息(环境变量) 第一次的项目想调用这个文件中的信息可以使用一个包dotenv
如果明文信息不放心 可以使用一个新的依赖 .env.enc
npx hardhat run scripts/deployFundMe.js --network sepolia

验证合约:
可以使用hardhat中的verify
    1.在控制台验证 npx hardhat verify --network '测试网' '已部署合约的地址' "参数" 
        如有网络问题开始tun模式
    2.在代码中验证 
        scripts中使用函数
        npx hardhat run scripts/xxx.js --network 测试网
添加是否在使用 --network 测试网  
    1.在配置文件加chainId
    2.在scripts中加方法

合约交互脚本:
    以fundMe合约为例 eg:
        init 2 accounts
        fund contract with first account
        check balance of contract
        fund contract with second account
        check balance of contract
        check mapping 
    令一种方式 使用hardhat中得task(相当于拆分，分布式管理) npx hardhat help 
    npx hardhat 自定义task命令 --参数名 入参 --network 网络
