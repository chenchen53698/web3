### Hardhat

**Hardhat** 是一个强大的以太坊开发环境，专为智能合约开发、测试和部署而设计。

<font color="red">**前置准备**</font>:

1. vscode下载solidity插件(hardhat版本)，有代码标注
2. 不要使用pnpm重构后者下载hardhat版本如果你要使用ethers的v6版本！(它会使你的项目的ethers回退到5.8，由于它默认的存储机制！！！)
3. npx install hardhat --save-dev（只在开发环境使用）
4. npx hardat 创建项目

<font color="red">**文件夹解析**</font>:

1. **hardhat.config.js**:是 Hardhat 项目的配置文件
2. **contracts**:用于存放合约
3. **ignition**:用于管理 Hardhat Ignition 的部署模块和配置。它是hardhat自己创建的一套部署和调用合约的一个机制。(官网有详细的讲解)
4. **test**:用于存放用于测试contracts文件夹中合约的文件
5. **scripts**：用于存放本项目你想使用的合约脚本(该项目把合约部署验证等存放于此文件夹)
6. **tasks**：用于存放自定义命令的地方
7. **test**:用于存放测试文件
8. **deploy**：用于存放部署脚本
9. **helper-hardhat-config.js**：用于存放一些Hardhat 项目所需的配置信息，例如网络设置、合约地址、区块链上的区块确认时间等。（本文中存放了喂价的一些常量），方便管理。



**<font color="red">编译合约</font>**

1. 指令:npx hardhat compile  

2. 会多出2个文件夹

     artifacts --存储编译信息和引入过的合约

     cache --存储编译时间，编译时的配置，以后部署的信息



<font color="red">**部署合约及验证合约**</font>

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

3. <font color="red">**hardhat-deploy**</font>

   1. `hardhat-deploy` 是一个 Hardhat 插件，专门用于简化智能合约的部署和管理。它提供了一套强大的工具，使得部署合约、管理部署记录、重用部署脚本等操作更加方便。

   2. ```
      前置:
      npm install -D hardhat-deploy 
      在hardhat.congfig.js中
      require("hardhat-deploy");
      创建deploy文件夹，编写部署脚本
      ```

   3. ##### **`hardhat-deploy` 的核心功能**

      **1. 简化部署脚本**

      - 提供 `deploy` 函数，用于部署合约。
      - 自动记录部署结果，方便后续使用。

      **2. 多网络支持**

      - 支持多个网络（如本地网络、测试网、主网等）。
      - 可以为每个网络配置不同的部署脚本。

      **3. 部署记录**

      - 自动保存部署记录，包括合约地址、ABI 等。
      - 可以在其他脚本中重用这些记录。

      **4. 依赖管理**

      - 支持部署脚本之间的依赖关系。
      - 可以确保部署顺序正确。

   4. ##### **部署脚本的详细说明**

      ##### **1. `deploy` 函数**

      `deploy` 函数用于部署合约。它接受以下参数：

      - **合约名称**：要部署的合约名称（字符串）。
      - **选项**：
        - `from`：部署者的地址。
        - `args`：构造函数的参数（数组）。
        - `log`：是否打印部署日志（布尔值）。

      示例：

      ```
      await deploy("FundMe", {
        from: deployer,
        args: ["Hello, World!"], // 构造函数参数
        log: true,
      });
      ```

      ------

      ##### **2. `getNamedAccounts`**

      `getNamedAccounts` 用于获取命名账户。在 `hardhat.config.js` 中配置：

      ```
      namedAccounts: {
        deployer: {
          default: 0, // 默认使用第一个账户作为部署者
        },
      },
      ```

      在部署脚本中使用：

      ```
      const { deployer } = await getNamedAccounts();
      ```

      ------

      ##### **3. `deployments`**

      `deployments` 提供了部署相关的功能，例如：

      - **`deploy`**：部署合约。
      - **`get`**：获取已部署的合约信息。
      - **`save`**：手动保存部署记录。

      示例：

      ```
      const fundMe = await deployments.get("FundMe");
      console.log("FundMe address:", fundMe.address);
      ```

   5. **多网络支持**

      `hardhat-deploy` 支持为每个网络配置不同的部署脚本。例如，可以为 Sepolia 和本地网络分别编写部署脚本。

      ------

      **部署记录**

      `hardhat-deploy` 会自动保存部署记录，存储在 `deployments/` 目录下。每个网络的部署记录会保存在对应的子目录中。

      例如，部署到 Sepolia 网络后，可以在 `deployments/sepolia/` 目录下找到部署记录。

      ------

      **重用部署记录**

      在其他脚本中，可以使用 `deployments.get()` 获取已部署的合约信息。

      ```
      const fundMe = await deployments.get("FundMe");
      console.log("FundMe address:", fundMe.address);
      ```

      ------

      **依赖管理**

      `hardhat-deploy` 支持部署脚本之间的依赖关系。例如，可以在部署 `FundMe` 之前先部署 `Helper` 合约。

      ```
      module.exports = async ({ getNamedAccounts, deployments }) => {
        const { deploy } = deployments;
        const { deployer } = await getNamedAccounts();
      
        // 先部署 Helper 合约
        await deploy("Helper", {
          from: deployer,
          log: true,
        });
      
        // 再部署 FundMe 合约
        await deploy("FundMe", {
          from: deployer,
          args: [], // 构造函数参数
          log: true,
        });
      };
      ```

   6. `deployments.fixture()` 是 `hardhat-deploy` 插件提供的一个功能，用于运行一组部署脚本（fixtures），以便在测试或开发环境中快速设置合约状态。

      1. **运行部署脚本**：执行指定的部署脚本，部署合约并设置初始状态。
      2. **复用部署逻辑**：在测试或开发中复用相同的部署逻辑，确保环境一致性。
      3. **快速重置状态**：在测试中快速重置合约状态，避免测试之间的相互影响。
      4. **fixture 名称**：一个字符串数组，指定要运行的部署脚本名称。例如 `["fundme", "helper"]`。

   7. `module.exports.tags` 是一个可选的属性，用于为部署脚本添加标签（tags）。标签可以帮助你组织和筛选部署脚本，特别是在使用 `deployments.fixture()` 时。

   8. 指令

      ```
      npx hardhat deploy --tags 便签 --network 网络 --reset(重新部署合约，如果之前部署过依旧部署上次的)
      ```

   9. 官网https://www.npmjs.com/package/hardhat-deploy

   

4. #### <font color="red">**ethers.js**</font>

   1. 用于与以太坊区块链交互。它提供了简单易用的 API，可以用于连接以太坊节点、发送交易、部署合约、调用合约方法等。

   2. **API**:

      1. **ethers.getContractFactory()**用于获取合约工厂

         1. 通过 `ContractFactory.deploy()` 部署合约。
         2. 通过 `ContractFactory.attach()` 连接到已部署的合约。

      2. **ethers.waitForDeployment()** 会等待合约的部署交易被打包并确认，然后返回合约实例。

      3. **ethers.getSigners()** 用于获取当前连接的以太坊网络中的签名者（Signers）。签名者是具有私钥的账户，可以用于签署交易和与合约交互。

      4. **ethers.parseEther()**用于将以太坊的 ETH 单位转换为最小的单位 **wei**。方便在发送交易或与合约交互时处理 ETH 金额。

      5. .**ethers.provider.getBalance()**

         1. 查询指定地址的 ETH 余额。
         2. 返回一个 `BigNumber` 对象，表示余额的 wei 值。
         3. 可以与其他工具方法（如 `ethers.formatEther()`）结合使用，将余额转换为 ETH 单位。

      6. **deploymentTransaction()**是 `ethers.js` v6 中的一个属性，用于访问合约部署交易的详细信息。

      7. **deploymentTransaction().wait(5)**等待部署交易被打包并确认。可以指定最多等待的区块数（可选参数）。

      8. 仅列出了本案例中使用的API，详见官网(英文版)

         https://hardhat.org/hardhat-runner/plugins/nomicfoundation-hardhat-ethers

   3. **注意事项:**

      1. 本案例中使用的是install hardhat所自带的ethers无需下载，但是需要引入。
      2. ethers存在v5,v6两个版本，使用会有写法的不同，可能存在语法上的错误，可以使用 **ethers.version**查看版本
      
      

5. #### <font color="red">**hardhat-verify**</font>

   1.  用于将智能合约的源代码验证到 Etherscan 或类似的区块链浏览器上。验证合约源代码后，用户可以在区块链浏览器上查看合约的源代码，并与合约进行交互。
   2. 方式1在控制台验证 npx hardhat verify --network '测试网' '已部署合约的地址' "参数"
   3. 方式2在代码中验证 npx hardhat run scripts/xxx.js --network 测试网
   4. 详见官网(英文版) https://hardhat.org/hardhat-runner/plugins/nomicfoundation-hardhat-verify
   5. **注意事项:**需要将测试网的APIkey写入hardhat.config中

6. #### <font color="red">**hre**</font>

   1. 是 **Hardhat Runtime Environment** 的缩写，它是 Hardhat 提供的一个全局对象，包含了 Hardhat 的所有功能和方法。
   2. 以通过 `hre` 访问 Hardhat 的核心功能，例如：
      1. **`ethers`**：与以太坊网络交互。
      2. **`network`**：访问当前网络配置。
      3. **`config`**：访问 Hardhat 配置文件。
      4. **`run`**：运行其他任务。
      5. **`artifacts`**：访问编译后的合约信息。
   3. 你可以在任务、脚本和插件中使用 `hre` 来访问 Hardhat 的功能。

7. #### <font color="red">**task**</font>

   1. 允许你扩展 Hardhat 的功能，执行特定的操作（如部署合约、运行脚本、与合约交互等）。
   2. 它用于分布式管理项目，让代码的可阅读性更高，功能拆分的更细致
   3. **任务**：一个自定义命令，可以通过 `npx hardhat <任务名>` 运行。
   4. **参数**：任务可以接受参数，通过 `.addParam()` 或 `.addOptionalParam()` 定义。
   5. **操作**：任务的逻辑通过 `.setAction()` 方法定义。
   6. npx hardhat help  查看自定义的任务。

8. <font color="red">**测试**</font>

   1. 本文使用**Mocha**和**Chai**

   2. #### <font color="red">**Mocha**</font>

      1. **Mocha** 是一个流行的 JavaScript 测试框架，广泛用于编写和运行测试用例。

      2. 它支持异步测试、钩子函数（如 `before`、`after`）、断言库（如 `Chai`）等功能，非常适合测试智能合约。

      3. Mocha 使用 `describe` 和 `it` 来组织测试：

         - **`describe`**：定义一个测试套件（Test Suite），用于分组相关的测试用例。

         - **`it`**：定义一个测试用例（Test Case），包含具体的测试逻辑。

         - ```
           describe("FundMe", function () {
             it("Should deploy the contract", async function () {
               // 测试逻辑
             });
           
             it("Should allow funding", async function () {
               // 测试逻辑
             });
           });
           ```

      4. Mocha 提供了钩子函数，用于在测试前后执行特定操作：

         - **`before`**：在所有测试用例之前运行。

         - **`after`**：在所有测试用例之后运行。

         - **`beforeEach`**：在每个测试用例之前运行。

         - **`afterEach`**：在每个测试用例之后运行。

         - ```
           describe("FundMe", function () {
             before(async function () {
               // 在所有测试之前运行
             });
           
             beforeEach(async function () {
               // 在每个测试之前运行
             });
           
             it("Should deploy the contract", async function () {
               // 测试逻辑
             });
           });
           ```

           

      5. **异步测试**

         Mocha 支持异步测试，可以使用 `async/await` 或返回 `Promise`。

      6. **断言库**

         Mocha 本身不包含断言功能，但可以与断言库（如 `Chai`）结合使用。

         ```
         const { expect } = require("chai");
         
         it("Should return the correct balance", async function () {
           expect(await fundMe.getBalance()).to.equal(ethers.parseEther("0.1"));
         });
         ```

      7. Hardhat 默认使用 Mocha 作为测试框架。如果你之前install了hardhat，脚手架中有`@nomicfoundation/hardhat-toolbox`，它包含了 Mocha 和 Chai 等工具。

      8. **运行所有测试**：

         ```
         npx hardhat test
         ```

      9. **运行特定测试文件**：

         ```
         npx hardhat test test/FundMe.js
         ```

      10. **运行特定测试套件**：

          ```
          npx hardhat test --grep "FundMe"
          ```

      11. **生成测试覆盖率报告**：

          ```
          npx hardhat coverage
          ```

   3. #### <font color="red">**Chai**</font>

      1. **Chai** 是一个流行的断言库，用于在 JavaScript 测试中编写断言。它提供了多种断言风格，可以与测试框架（如 Mocha）结合使用，非常适合测试智能合约。

      2. Chai 支持三种断言风格：

         - **`expect`**：链式语法，易于阅读。
         - **`should`**：BDD 风格，扩展对象的原型。
         - **`assert`**：TDD 风格，类似于 Node.js 的 `assert` 模块。

      3. ##### **常用断言方法**

         - **`.equal`**：严格相等（`===`）。
         - **`.deep.equal`**：深度相等（适用于对象和数组）。
         - **`.include`**：检查是否包含某个值。
         - **`.above`**：检查是否大于某个值。
         - **`.below`**：检查是否小于某个值。
         - **`.true`**：检查是否为 `true`。
         - **`.false`**：检查是否为 `false`。
         - **`.throw`**：检查是否抛出异常。

      4. **链式语法**

         Chai 的 `expect` 和 `should` 风格支持链式语法，使断言更加清晰。

         示例：

         ```
         expect(1 + 1)
           .to.be.a("number")
           .and.to.equal(2)
           .and.to.be.below(3);
         ```

      5. Hardhat 默认集成了 Chai，可以直接在测试中使用。

   4. #### <font color="red">**mock合约**</font>

      1. **Mock 合约** 是一种用于测试的模拟合约，通常用于**模拟外部依赖**或**复杂逻辑**。
      2. 位置:放在contracts下，新建一个mocks文件夹用于存放mock合约。
      3. 写法:像正常合约一样书写，或者引入。(需要**编译**和**部署**)
   
   5. <font color="red">**@nomicfoundation/hardhat-network-helpers**</font>
   
      1. 是一个 Hardhat 插件，提供了一些实用的工具函数，用于在测试中操作 Hardhat 网络。这些工具函数可以帮助你模拟时间、区块、账户状态等，使测试更加灵活和强大。
   
      2. **`hardhat-network-helpers` 的核心功能**
   
         **1. 时间操作**
   
         - **`time.increase()`**：增加区块链的时间。
         - **`time.increaseTo()`**：将区块链的时间增加到指定的时间戳。
         - **`time.latest()`**：获取最新的区块时间戳。
   
         **2. 区块操作**
   
         - **`mine()`**：挖一个新区块。
         - **`mineUpTo()`**：挖到指定的区块号。
         - **`setNextBlockTimestamp()`**：设置下一个区块的时间戳。
   
         **3. 账户操作**
   
         - **`setBalance()`**：设置指定账户的余额。
         - **`impersonateAccount()`**：模拟指定账户的行为。
         - **`stopImpersonatingAccount()`**：停止模拟指定账户的行为。
   
         **4. 其他工具**
   
         - **`loadFixture()`**：加载并运行一个 fixture 函数，用于设置测试环境。
         - **`takeSnapshot()`**：创建一个区块链状态的快照。
         - **`restoreSnapshot()`**：恢复到指定的快照。
   
      3. 
   
   6. 
   
      
   
      
   
   
   
   