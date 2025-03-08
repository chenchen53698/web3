### Hardhat

**Hardhat** 是一个强大的以太坊开发环境，专为智能合约开发、测试和部署而设计。

前置准备:

1. vscode下载solidity插件(hardhat版本)，有代码标注
2. npx install hardhat --save-dev（只在开发环境使用）
3. npx hardat 创建项目

文件夹解析:

1. **hardhat.config.js**:是 Hardhat 项目的配置文件
2. **contracts**:用于存放合约
3. **ignition**:用于管理 Hardhat Ignition 的部署模块和配置。它是hardhat自己创建的一套部署和调用合约的一个机制。(官网有详细的讲解)
4. **test**:用于存放用于测试contracts文件夹中合约的文件
5. **scripts**：用于存放本项目你想使用的合约脚本(该项目把合约部署验证等存放于此文件夹)
6. **tasks**：用于存放自定义命令的地方

**编译合约**

1. 指令:npx hardhat compile  

2. 会多出2个文件夹

     artifacts --存储编译信息和引入过的合约

     cache --存储编译时间，编译时的配置，以后部署的信息

**部署合约及验证合约**

1. 本文使用了**ethers.js**进行部署，**verify**进行验证

2. 前置需要在hardhat.config.js中配置一些文件(来**部署到测试网**上)

   ```
   module.exports = {
     // defaultNetwork: "hardhat",  默认网络--本地测试网络
     solidity: "0.8.28",
     networks: {//网络配置
       //部署成功后，可以在https://sepolia.etherscan.io/上查看合约
       sepolia: {
         url: SEPOLIA_URL,//使用alchemy来连接到测试网
         accounts: [PRIVATE_KEY,PRIVATE_KEY_1],//你的私钥
         chainId: 11155111//链ID
       }
     },
     etherscan: {//etherscan配置,用于验证合约
       apiKey: {
         sepolia: ETHERSCAN_API_KEY
       }
     }
   };
   ```

   

3. **ethers.js**

   1. 用于与以太坊区块链交互。它提供了简单易用的 API，可以用于连接以太坊节点、发送交易、部署合约、调用合约方法等。

   2. **API**:

      1. ethers.getContractFactory()用于获取合约工厂

         1. 通过 `ContractFactory.deploy()` 部署合约。
         2. 通过 `ContractFactory.attach()` 连接到已部署的合约。

      2. ethers.waitForDeployment() 会等待合约的部署交易被打包并确认，然后返回合约实例。

      3. ethers.getSigners() 用于获取当前连接的以太坊网络中的签名者（Signers）。签名者是具有私钥的账户，可以用于签署交易和与合约交互。

      4. ethers.parseEther()用于将以太坊的 ETH 单位转换为最小的单位 **wei**。方便在发送交易或与合约交互时处理 ETH 金额。

      5. .ethers.provider.getBalance()

         1. 查询指定地址的 ETH 余额。
         2. 返回一个 `BigNumber` 对象，表示余额的 wei 值。
         3. 可以与其他工具方法（如 `ethers.formatEther()`）结合使用，将余额转换为 ETH 单位。

      6. deploymentTransaction()是 `ethers.js` v6 中的一个属性，用于访问合约部署交易的详细信息。

      7. deploymentTransaction().wait(5)等待部署交易被打包并确认。可以指定最多等待的区块数（可选参数）。

      8. 仅列出了本案例中使用的API，详见官网(英文版)

         https://hardhat.org/hardhat-runner/plugins/nomicfoundation-hardhat-ethers

   3. **注意事项:**

      1. 本案例中使用的是install hardhat所自带的ethers无需下载，但是需要引入。
      2. ethers存在v5,v6两个版本，使用会有写法的不同，可能存在语法上的错误，可以使用 **ethers.version**查看版本

4. **hardhat-verify**

   1.  用于将智能合约的源代码验证到 Etherscan 或类似的区块链浏览器上。验证合约源代码后，用户可以在区块链浏览器上查看合约的源代码，并与合约进行交互。
   2. 方式1在控制台验证 npx hardhat verify --network '测试网' '已部署合约的地址' "参数"
   3. 方式2在代码中验证 npx hardhat run scripts/xxx.js --network 测试网
   4. 详见官网(英文版) https://hardhat.org/hardhat-runner/plugins/nomicfoundation-hardhat-verify
   5. **注意事项:**需要将测试网的APIkey写入hardhat.config中

5. **hre**

   1. 是 **Hardhat Runtime Environment** 的缩写，它是 Hardhat 提供的一个全局对象，包含了 Hardhat 的所有功能和方法。
   2. 以通过 `hre` 访问 Hardhat 的核心功能，例如：
      1. **`ethers`**：与以太坊网络交互。
      2. **`network`**：访问当前网络配置。
      3. **`config`**：访问 Hardhat 配置文件。
      4. **`run`**：运行其他任务。
      5. **`artifacts`**：访问编译后的合约信息。
   3. 你可以在任务、脚本和插件中使用 `hre` 来访问 Hardhat 的功能。

6. **task**

   1. 允许你扩展 Hardhat 的功能，执行特定的操作（如部署合约、运行脚本、与合约交互等）。
   2. 它用于分布式管理项目，让代码的可阅读性更高，功能拆分的更细致
   3. **任务**：一个自定义命令，可以通过 `npx hardhat <任务名>` 运行。
   4. **参数**：任务可以接受参数，通过 `.addParam()` 或 `.addOptionalParam()` 定义。
   5. **操作**：任务的逻辑通过 `.setAction()` 方法定义。
   6. npx hardhat help  查看自定义的任务

   

   