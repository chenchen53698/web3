// 这里使用ethers进行部署
// execute main funtion
// import ethers
const { ethers,network } = require("hardhat");
const { networkConfig} = require("../helper-hardhat-config")
console.log("Hardhat内置的ethers.js版本:", ethers.version);
//下属写法是ethers.js6.0.0版本的写法
// create main function
async function main() {
    console.log('start')
    //create factory
    // const fundMeFactory = await ethers.getContractFactory("合约名字","不写默认使用配置文件第一个私钥，写了就用写入的私钥")
    const fundMeFactory = await ethers.getContractFactory("FundMe")
    console.log('start2')
    //deploy contract  deploy() 并不保证立即返回部署的合约地址,需要等待部署完成
    const fundMe = await fundMeFactory.deploy(300,networkConfig[network.config.chainId].ethUsdDataFeed)
    console.log('start3')
    await fundMe.waitForDeployment()
    console.log(`contract has been deployed successfully, contract address is ${fundMe.target}`);

    //verify contract on etherscan 需要在hardhat.config.js中配置etherscan的apiKey
    if (hre.network.config.chainId == 11155111 && process.env.ETHERSCAN_API_KEY) {
        //等待5个确认，提高成功率因为我们部署成功后，需要等待一段时间，才能在etherscan上看到合约
        console.log("Waiting for 5 confirmations")
        await fundMe.deploymentTransaction().wait(5)
        await verifyFundMe(fundMe.target, [300,networkConfig[network.config.chainId].ethUsdDataFeed])
    } else {
        console.log("no etherscan api key found, skipping verification")
    }

    //init 2 accounts
    const [firstAccount, secondAccount] = await ethers.getSigners()
    //fund contract with first account    ethers.parseEther('0.5')将0.5个以太转换为wei
    const funTx = await fundMe.fund({ value: ethers.parseEther('0.5') })
    await funTx.wait() //wait() 是一个常用的方法，通常用于等待交易被打包并确认。
    //check balance of contract  ethers.provider.getBalance(fundMe.target)获取合约地址的余额
    const balanceOfContract = await ethers.provider.getBalance(fundMe.target)
    console.log(`Balance of the contract is ${balanceOfContract}`)
    //fund contract with second account
    const fundTxWithSecondAccount = await fundMe.connect(secondAccount).fund({ value: ethers.parseEther("0.5") })
    await fundTxWithSecondAccount.wait()
    //check balance of contract
    const balanceOfContractAfterSecondFund = await ethers.provider.getBalance(fundMe.target)
    console.log(`Balance of the contract is ${balanceOfContractAfterSecondFund}`)
    //check mapping 
    const firstAccountbalanceInFundMe = await fundMe.fundersToAmount(firstAccount.address)
    const secondAccountbalanceInFundMe = await fundMe.fundersToAmount(secondAccount.address)
    console.log(`Balance of first account ${firstAccount.address} is ${firstAccountbalanceInFundMe}`)
    console.log(`Balance of second account ${secondAccount.address} is ${secondAccountbalanceInFundMe}`)
}
async function verifyFundMe(fundMeAddr, args) {
    await hre.run("verify:verify", {
        address: fundMeAddr,
        constructorArguments: args,
    });
}
main().then().catch((error) => {
    console.error(error)
    process.exit(1)//退出进程 非正常退出使用1 正常退出使用0
})