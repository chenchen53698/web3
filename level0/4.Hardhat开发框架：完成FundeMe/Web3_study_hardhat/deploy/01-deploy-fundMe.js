
// function deployFunction() {
//     console.log("this is a deploy function")
// }
// module.exports.default = deployFunction

// module.exports = async (hre) => {
//     const getNamedAccounts = hre.getNamedAccounts
//     const deployments = hre.deployments
//     console.log("this is a deploy function")
// }
const { network } = require("hardhat")
const { devlopmentChains, networkConfig, LOCK_TIME,CONFIRMATIONS } = require("../helper-hardhat-config")
module.exports = async ({ getNamedAccounts, deployments }) => {
    const { firstAccount } = await getNamedAccounts()
    const { deploy } = deployments//deploy是一个函数,部署合约
    // console.log(`this is a deploy function ${firstAccount,deploy}`)
    let dataFeedAddr
    let confirmations
    //判断并获取常量
    if (devlopmentChains.includes(network.name)) {//本地
        const mockV3Aggregator = await deployments.get("MockV3Aggregator")
        dataFeedAddr = mockV3Aggregator.address
        confirmations = 0
    } else {
        dataFeedAddr = networkConfig[network.config.chainId].ethUsdDataFeed
        confirmations = CONFIRMATIONS
    }
    //部署
    const fundMe = await deploy("FundMe", {
        from: firstAccount,//部署者的地址。
        args: [LOCK_TIME, dataFeedAddr],//构造函数的参数（数组）。
        log: true,//是否打印部署日志（布尔值）。
        waitConfirmations: confirmations//等待区块确认数
    })
    //验证
    if (hre.network.config.chainId == 11155111 && process.env.ETHERSCAN_API_KEY) {
        await hre.run("verify:verify", {
            address: fundMe.address,
            constructorArguments: [LOCK_TIME, dataFeedAddr],
        });
    } else {
        console.log("Network is not sepolia, verification skipped...")
    }
}

module.exports.tags = ["all", "fundme"]//用于为部署脚本添加标签（tags）
