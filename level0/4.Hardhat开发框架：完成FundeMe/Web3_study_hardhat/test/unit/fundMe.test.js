const { ethers,deployments,getNamedAccounts } = require("hardhat");
const { expect, assert } = require("chai");
const helpers = require("@nomicfoundation/hardhat-network-helpers");
//describe 测试用例, it 测试单元
describe("test fundme contract", async function () {
    let fundMe
    let firstAccount
    let mockV3Aggregator
    before(async function () {// 在所有测试之前运行
        console.log("Hardhat内置的ethers.js版本:", ethers.version);
        await deployments.fixture(["all"]);// 部署合约 是hardhat-deploy插件提供的一个功能，用于运行一组部署脚本（fixtures）
        firstAccount = (await getNamedAccounts()).firstAccount;
        const fundMeDeployment = await deployments.get("FundMe");// 获取已部署合约的信息
        mockV3Aggregator = await deployments.get("MockV3Aggregator");
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
        assert.equal(await fundMe.dataFeed(),mockV3Aggregator.address);
    })

    //fund ,getFund , refund

    // fund 函数，用于捐款，捐款金额小于最小值，捐款失败
    it("window closed,value greater than minimum , fund failed", async function () {
        //make sure the window is closed
        await helpers.time.increase(200);// 增加时间 lockTime是180秒，增加200秒，窗口已经关闭
        await helpers.mine();// 挖一个新区块 使时间增加生效
        //value is greater than minimum
        //.to.be.revertedWith("xxx")：使用 Chai 的 revertedWith 方法，验证交易是否因 revert 而失败。
        //具体检查合约在执行失败时，是否抛出与 "xxx" 完全匹配的错误信息。（xxx不是瞎写的应该与合约中的断言一致！） ??有疑问
        expect(fundMe.fund({value:ethers.parseEther("0.1")})).to.be.revertedWith("window is closed");
        
    })
});
