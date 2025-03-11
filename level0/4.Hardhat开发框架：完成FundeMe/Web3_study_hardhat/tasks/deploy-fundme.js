const { task } = require("hardhat/config")
// const { network } = require("hardhat");
const { networkConfig} = require("../helper-hardhat-config")
task("deploy-fundme", "deploy and verify fundme conract").setAction(async(taskArgs, hre) => {
    // create factory 
    const fundMeFactory = await ethers.getContractFactory("FundMe", {
        gasPrice: ethers.parseUnits("30", "gwei"), // 设置更高的 Gas 价格
      });   
    console.log("contract deploying")
    // deploy contract from factory
    const fundMe = await fundMeFactory.deploy(300,networkConfig[network.config.chainId].ethUsdDataFeed)
    await fundMe.waitForDeployment()
    console.log(`contract has been deployed successfully, contract address is ${fundMe.target}`);

    // verify fundme
    if(hre.network.config.chainId == 11155111 && process.env.ETHERSCAN_API_KEY) {
        console.log("Waiting for 5 confirmations")
        await fundMe.deploymentTransaction().wait(5) 
        await verifyFundMe(fundMe.target, [300,networkConfig[network.config.chainId].ethUsdDataFeed])
    } else {
        console.log("verification skipped..")
    }
} )

async function verifyFundMe(fundMeAddr, args) {
    await hre.run("verify:verify", {
        address: fundMeAddr,
        constructorArguments: args,
      });
}

module.exports = {}