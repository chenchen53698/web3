// 这里使用ethers进行部署
// execute main funtion
// import ethers
const { ethers } = require("hardhat");
console.log("Hardhat内置的ethers.js版本:", ethers.version);
//下属写法是ethers.js6.0.0版本的写法
// create main function
async function main(){
    //create factory
    const fundMeFactory = await ethers.getContractFactory("FundMe")
    //deploy contract  deploy() 并不保证立即返回部署的合约地址,需要等待部署完成
    const fundMe = await fundMeFactory.deploy(10)
    await fundMe.waitForDeployment()
    console.log(`contract has been deployed successfully, contract address is ${fundMe.target}`);
}
main().then().catch((error)=>{
    console.error(error)
    process.exit(1)//退出进程 非正常退出使用1 正常退出使用0
})