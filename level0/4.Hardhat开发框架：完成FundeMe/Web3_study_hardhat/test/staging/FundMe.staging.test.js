/*
    集成测试
    主要是覆盖单元测试无法覆盖的2个点
    1. 并没有考虑网络延迟，条件等
    2. 合约和外部的交互(第三方服务)
*/
const { ethers, deployments, getNamedAccounts } = require("hardhat");
const { expect, assert } = require("chai");
const {devlopmentChains} = require("../../helper-hardhat-config")
//describe 测试用例, it 测试单元  describe.skip 跳过测试
devlopmentChains.includes(network.name)
? describe.skip
: describe("test fundme contract", async function () {
    let fundMe
    let firstAccount
    beforeEach(async function () {// 在每个测试之前运行
        await deployments.fixture(["all"]);// 部署合约 是hardhat-deploy插件提供的一个功能，用于运行一组部署脚本（fixtures）
        firstAccount = (await getNamedAccounts()).firstAccount;
        const fundMeDeployment = await deployments.get("FundMe");// 获取已部署合约的信息
        try {
            fundMe = await ethers.getContractAt("FundMe", fundMeDeployment.address);// 是 ethers.js 中的一个方法，用于连接到已经部署的合约。可以帮助你复用已部署的合约。
        } catch (error) {
            console.error("Error loading contract:", error.message);
        }
    })

    it("fund and getFund successfully", 
        async function() {
            // make sure target reached
            await fundMe.fund({value: ethers.parseEther("0.8")}) // 3000 * 0.5 = 1500
            // make sure window closed
            await new Promise(resolve => setTimeout(resolve, 181 * 1000))
            // make sure we can get receipt 
            const getFundTx = await fundMe.getFund()
            const getFundReceipt = await getFundTx.wait()
            expect(getFundReceipt)
                .to.be.emit(fundMe, "FundWithdrawByOwner")
                .withArgs(ethers.parseEther("0.8"))
        }
    )

    it("fund and refund successfully",
        async function() {
            // make sure target not reached
            await fundMe.fund({value: ethers.parseEther("0.1")}) // 3000 * 0.1 = 300
            // make sure window closed
            await new Promise(resolve => setTimeout(resolve, 181 * 1000))
            // make sure we can get receipt 
            const refundTx = await fundMe.refund()
            const refundReceipt = await refundTx.wait()
            expect(refundReceipt)
                .to.be.emit(fundMe, "RefundByFunder")
                .withArgs(firstAccount, ethers.parseEther("0.1"))
        }
    )
});
