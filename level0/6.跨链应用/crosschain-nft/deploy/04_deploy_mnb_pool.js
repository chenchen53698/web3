const { network } = require("hardhat")
const { developmentChains, networkConfig } = require("../helper-hardhat-config")
module.exports = async({getNamedAccounts, deployments}) => {
    const {firstAccount} = await getNamedAccounts()
    const {deploy, log} = deployments
    
    log("NFTPoolBurnAndMint deploying...")
    // address _router,address _link,address nftAddr
    let destChainRouter
    let linkToken
    let wnftAddr

    if (developmentChains.includes(network.name)) {
        const ccipSimulatorDeployment = await deployments.get("CCIPLocalSimulator")
        const ccipSimulator = await ethers.getContractAt("CCIPLocalSimulator", ccipSimulatorDeployment.address)
        //依赖包提供的方法
        const ccipConfig = await ccipSimulator.configuration()
        destChainRouter = ccipConfig.destinationRouter_
        linkToken = ccipConfig.linkToken_
    } else {
        destChainRouter = networkConfig[network.config.chainId].router
        linkToken = networkConfig[network.config.chainId].linkToken
    }
    
     
    const wnftTx = await deployments.get("WrappedMyToken")
    wnftAddr = wnftTx.address
    await deploy("NFTPoolBurnAndMint", {
        contract: "NFTPoolBurnAndMint",
        from: firstAccount,
        log: true,
        args: [destChainRouter, linkToken, wnftAddr]
    })
    log("NFTPoolBurnAndMint is deployed!")
}

module.exports.tags = ["all", "destchain"]