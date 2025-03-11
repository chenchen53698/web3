const { DECIMAL, INITIAL_ANSWER,devlopmentChains } = require("../helper-hardhat-config")
module.exports = async ({ getNamedAccounts, deployments }) => {
    if (devlopmentChains.includes(network.name)) {//本地
        const { firstAccount } = await getNamedAccounts()
        const { deploy } = deployments//deploy是一个函数,部署合约

        await deploy("MockV3Aggregator", {
            from: firstAccount,//部署者的地址。
            args: [DECIMAL, INITIAL_ANSWER],//构造函数的参数（数组）。
            log: true//是否打印部署日志（布尔值）。
        })
    } else {
        console.log("environment is not local, mock contract depployment is skipped")
    }

}

module.exports.tags = ["all", "mock"]//用于为部署脚本添加标签（tags）