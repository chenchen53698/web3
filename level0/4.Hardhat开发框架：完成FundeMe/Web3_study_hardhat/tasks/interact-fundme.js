const { task } = require("hardhat/config")
// task(名字，描述).setAction(异步函数(taskArgs, hre) => {})
// taskArgs 包含传入的参数（如 addr）。hre 为 Hardhat Runtime Environment，提供了 Hardhat 的所有功能。
// addParam("addr", "The address of the FundMe contract")：添加一个参数 addr，用于指定 FundMe 合约的地址。
// 如果想传入多个参数可以 再 .addParam("addr", "fundme contract address") 后面继续添加 .addParam("xxx", "xxx")。
task("interact-fundme", "interact with fundme contract")
    .addParam("addr", "fundme contract address")
    .setAction(async(taskArgs, hre) => {
        const fundMeFactory = await ethers.getContractFactory("FundMe")
        const fundMe = fundMeFactory.attach(taskArgs.addr)//attach() 方法用于连接到已部署的合约，传入合约地址即可。

        // init 2 accounts
        const [firstAccount, secondAccount] = await ethers.getSigners()
    
        // fund contract with first account
        const fundTx = await fundMe.fund({value: ethers.parseEther("0.5")})
        await fundTx.wait()
    
        // check balance of contract
        const balanceOfContract = await ethers.provider.getBalance(fundMe.target)
        console.log(`Balance of the contract is ${balanceOfContract}`)
    
        // fund contract with second account
        const fundTxWithSecondAccount = await fundMe.connect(secondAccount).fund({value: ethers.parseEther("0.5")})
        await fundTxWithSecondAccount.wait()
    
        // check balance of contract
        const balanceOfContractAfterSecondFund = await ethers.provider.getBalance(fundMe.target)
        console.log(`Balance of the contract is ${balanceOfContractAfterSecondFund}`)
    
        // check mapping 
        const firstAccountbalanceInFundMe = await fundMe.fundersToAmount(firstAccount.address)
        const secondAccountbalanceInFundMe = await fundMe.fundersToAmount(secondAccount.address)
        console.log(`Balance of first account ${firstAccount.address} is ${firstAccountbalanceInFundMe}`)
        console.log(`Balance of second account ${secondAccount.address} is ${secondAccountbalanceInFundMe}`)
})

module.exports = {}