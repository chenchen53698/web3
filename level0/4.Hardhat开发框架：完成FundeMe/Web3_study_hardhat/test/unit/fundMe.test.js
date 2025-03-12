const { ethers, deployments, getNamedAccounts } = require("hardhat");
const { expect, assert } = require("chai");
const helpers = require("@nomicfoundation/hardhat-network-helpers");
const {devlopmentChains} = require("../../helper-hardhat-config")
//describe 测试用例, it 测试单元
//这是一个fundme合约的单元测试，测试合约的重要功能，去保证合约的安全性，它又可以完全在本地运行，测试效率高。
!devlopmentChains.includes(network.name)
? describe.skip
: describe("test fundme contract", async function () {
    let fundMe
    let fundMeSecondAccount
    let firstAccount
    let secondAccount
    let mockV3Aggregator
    before(async function () {// 在所有测试之前运行
        console.log("Hardhat内置的ethers.js版本:", ethers.version);
        firstAccount = (await getNamedAccounts()).firstAccount;
        secondAccount = (await getNamedAccounts()).secondAccount;
    });

    beforeEach(async function () {// 在每个测试之前运行
        await deployments.fixture(["all"]);// 部署合约 是hardhat-deploy插件提供的一个功能，用于运行一组部署脚本（fixtures）
        const fundMeDeployment = await deployments.get("FundMe");// 获取已部署合约的信息

        mockV3Aggregator = await deployments.get("MockV3Aggregator");
        try {
            fundMe = await ethers.getContractAt("FundMe", fundMeDeployment.address);// 是 ethers.js 中的一个方法，用于连接到已经部署的合约。可以帮助你复用已部署的合约。
            fundMeSecondAccount = await ethers.getContract("FundMe", secondAccount);
        } catch (error) {
            console.error("Error loading contract:", error.message);
        }
    })

    it("test if the owner is msg.sender", async function () {
        await fundMe.waitForDeployment();
        // assert.equal(a, b)：断言 a 是否等于 b，不等则抛出异常。owner() 是合约的方法，返回合约的所有者。
        assert.equal(await fundMe.owner(), firstAccount);
    })

    it("test if the dataFeed is assigned corrcetly 正确赋值", async function () {
        await fundMe.waitForDeployment();
        assert.equal(await fundMe.dataFeed(), mockV3Aggregator.address);
    })

    // fund 函数，用于捐款，捐款金额小于最小值，捐款失败
    it("window closed,value greater than minimum , fund failed", async function () {
        //make sure the window is closed
        await helpers.time.increase(200);// 增加时间 lockTime是180秒，增加200秒，窗口已经关闭
        await helpers.mine();// 挖一个新区块 使时间增加生效
        //value is greater than minimum
        //.to.be.revertedWith("xxx")：使用 Chai 的 revertedWith 方法，验证交易是否因 revert 而失败。
        //具体检查合约在执行失败时，是否抛出与 "xxx" 完全匹配的错误信息。（xxx不是瞎写的应该与合约中的断言一致！）
        await expect(fundMe.fund({ value: ethers.parseEther("0.1") })).to.be.revertedWith("window is closed");
    })

    it("window open, value is less than minimum, fund failed", async function () {
        await expect(fundMe.fund({ value: ethers.parseEther("0.01") }))
            .to.be.revertedWith("Send more ETH")
    })

    it("Window open, value is greater minimum, fund success", async function () {
        await fundMe.fund({ value: ethers.parseEther("0.1") })
        const balance = await fundMe.fundersToAmount(firstAccount)
        await expect(balance).to.equal(ethers.parseEther("0.1"))
    })

    //getFund 在锁定期内，达到目标值，生产商可以提款
    it("not onwer, window closed, target reached, getFund failed",
        async function () {
            await fundMe.fund({ value: ethers.parseEther("1") })
            await helpers.time.increase(200)
            await helpers.mine()
            await expect(fundMeSecondAccount.getFund())
                .to.be.revertedWith("this function can only be called by owner")
        }
    )

    it("window open, target reached, getFund failed",
        async function () {
            await fundMe.fund({ value: ethers.parseEther("1") })
            await expect(fundMe.getFund())
                .to.be.revertedWith("window is not closed")
        }
    )

    it("window closed, target not reached, getFund failed",
        async function() {
            await fundMe.fund({value: ethers.parseEther("0.1")})
            // make sure the window is closed
            await helpers.time.increase(200)
            await helpers.mine()            
            await expect(fundMe.getFund())
                .to.be.revertedWith("Target is not reached")
        }
    )

    it("window closed, target reached, getFund success", 
        async function() {
            await fundMe.fund({value: ethers.parseEther("1")})
            // make sure the window is closed
            await helpers.time.increase(200)
            await helpers.mine()   
            await expect(fundMe.getFund())
                .to.emit(fundMe, "FundWithdrawByOwner")//用于验证合约是否触发了指定的事件。第一个参数是合约实例，第二个参数是事件名称（字符串）。
                .withArgs(ethers.parseEther("1"))//用于验证事件的参数是否符合预期。参数顺序和类型必须与事件定义一致。
        }
    )
    //reFund 在锁定期内，没有达到目标值，投资人可以退款
    it("window open, target not reached, funder has balance", 
        async function() {
            await fundMe.fund({value: ethers.parseEther("0.1")})
            await expect(fundMe.refund())
                .to.be.revertedWith("window is not closed");
        }
    )

    it("window closed, target reach, funder has balance", 
        async function() {
            await fundMe.fund({value: ethers.parseEther("1")})
            // make sure the window is closed
            await helpers.time.increase(200)
            await helpers.mine()  
            await expect(fundMe.refund())
                .to.be.revertedWith("Target is reached");
        }
    )

    it("window closed, target not reach, funder does not has balance", 
        async function() {
            await fundMe.fund({value: ethers.parseEther("0.1")})
            // make sure the window is closed
            await helpers.time.increase(200)
            await helpers.mine()  
            await expect(fundMeSecondAccount.refund())
                .to.be.revertedWith("there is no fund for you");
        }
    )

    it("window closed, target not reached, funder has balance", 
        async function() {
            await fundMe.fund({value: ethers.parseEther("0.1")})
            // make sure the window is closed
            await helpers.time.increase(200)
            await helpers.mine()  
            await expect(fundMe.refund())
                .to.emit(fundMe, "RefundByFunder")
                .withArgs(firstAccount, ethers.parseEther("0.1"))
        }
    )
});
