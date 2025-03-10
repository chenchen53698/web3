
// function deployFunction() {
//     console.log("this is a deploy function")
// }
// module.exports.default = deployFunction

// module.exports = async (hre) => {
//     const getNamedAccounts = hre.getNamedAccounts
//     const deployments = hre.deployments
//     console.log("this is a deploy function")
// }

module.exports = async ({getNamedAccounts,deployments}) => {
    const {firstAccount} = await getNamedAccounts()
    const {deploy} = deployments//deploy是一个函数,部署合约
    // console.log(`this is a deploy function ${firstAccount,deploy}`)
    await deploy("FundMe", {
        from: firstAccount,//部署者的地址。
        args: [180],//构造函数的参数（数组）。
        log: true//是否打印部署日志（布尔值）。
    })
}

module.exports.tags=["all","fundme"]//用于为部署脚本添加标签（tags）
