const { ethers,deployments,getNamedAccounts } = require("hardhat");
const { expect, assert } = require("chai");

//describe 测试用例, it 测试单元
describe("test fundme contract", async function () {
    let fundMe
    let firstAccount
    before(async function () {// 在所有测试之前运行
        console.log("Hardhat内置的ethers.js版本:", ethers.version);
        await deployments.fixture(["all"]);// 部署合约 是hardhat-deploy插件提供的一个功能，用于运行一组部署脚本（fixtures）
        firstAccount = (await getNamedAccounts()).firstAccount;
        const fundMeDeployment = await deployments.get("FundMe");// 获取已部署合约的信息
        try {
            fundMe = await ethers.getContractAt("FundMe",fundMeDeployment.address);// 是 ethers.js 中的一个方法，用于连接到已经部署的合约。可以帮助你复用已部署的合约。
        } catch (error) {
            console.error("Error loading contract:", error.message);
        }
    });
    
    it("test if the owner is msg.sender", async function () {
        await fundMe.waitForDeployment();
        // assert.equal(a, b)：断言 a 是否等于 b，不等则抛出异常。owner() 是合约的方法，返回合约的所有者。
        assert.equal(await fundMe.owner(), firstAccount);
    })

    it("test if the dataFeed is assigned corrcetly 正确赋值", async function () {
        await fundMe.waitForDeployment();
        assert.equal(await fundMe.dataFeed(), "0x694AA1769357215DE4FAC081bf1f309aDC325306");
    })
});
