const { ethers, deployments, getNamedAccounts } = require("hardhat");
const { expect, assert } = require("chai");

let firstAccount
let nft
let wnft
let poolLnU
let poolMnB
let ccipLocalSimulator
let chainSelector
before(async function () {// 在所有测试之前运行
    firstAccount = (await getNamedAccounts()).firstAccount;
    await deployments.fixture(["all"]);// 部署合约 是hardhat-deploy插件提供的一个功能，用于运行一组部署脚本（fixtures）
    nft = await ethers.getContract("MyToken", firstAccount)
    wnft = await ethers.getContract("WrappedMyToken", firstAccount)
    poolLnU = await ethers.getContract("NFTPoolLockAndRelease", firstAccount)
    poolMnB = await ethers.getContract("NFTPoolBurnAndMint", firstAccount)
    ccipLocalSimulator = await ethers.getContract("CCIPLocalSimulator", firstAccount)
    // 获取链选择器，ccip中configuration中返回的
    chainSelector = (await ccipLocalSimulator.configuration()).chainSelector_
})

describe("source chain -> dest chain tests", async function () {
    // 测试用户是否可以成功从nft合约中铸造nft   
    it("test if user can mint a nft from nft contract successfully", async function () {
        await nft.safeMint(firstAccount);
        const owner = await nft.ownerOf(0);// ownerOf 是ERC721的方法，返回tokenId的所有者
        expect(owner).to.equal(firstAccount);
    })
    // 测试用户是否可以成功将nft锁定在池中并在源链上发送ccip消息
    it("test if user can lock the nft in the pool and send ccip message on source chain", async function () {
        //都是由于ccip协议中的一些先决条件: 1.你需要有足够的余额支付 2. poolLnU中有调用到nft合约的方法，所以需要授权
        //1.ccip中的requestLinkFromFaucet方法用于从faucet请求链上资产
        await ccipLocalSimulator.requestLinkFromFaucet(poolLnU.target, ethers.parseEther("10"))
        // //2.ERC-721中授权另一个地址转移 NFT,通过 tokenId 标识 0
        await nft.approve(poolLnU.target, 0)
        // //3.调用poolLnU合约的lockAndSendNFT方法，需要传参: tokenId, to newOwner, 链选择器,目标池
        await poolLnU.lockAndSendNFT(0, firstAccount, chainSelector, poolMnB.target)

        const owner = await nft.ownerOf(0);
        expect(owner).to.equal(poolLnU);
    })
    // 测试用户是否可以在目标链上获取包装的nft
    it("test if user can get a wrapped nft in dest chain", async function () {
        const owner = await wnft.ownerOf(0);// ownerOf 是ERC721的方法，返回tokenId的所有者
        expect(owner).to.equal(firstAccount);
    })
})

describe("dest chain -> source chain tests", async function () {
    // 测试用户是否可以成功销毁wnft并在目标链上发送ccip消息
    it("test if user can burn the wnft and send ccip message on dest chain", async function () {
        await wnft.approve(poolMnB.target, 0)
        await ccipLocalSimulator.requestLinkFromFaucet(poolMnB.target, ethers.parseEther("10"))
        await poolMnB.burnAndSendNFT(0, firstAccount, chainSelector, poolLnU.target)
        //totalSupply 是ERC721的方法，返回总的NFT数量
        const wnftTotalSupply = await wnft.totalSupply()
        expect(wnftTotalSupply).to.equal(0)
    })

    // 测试用户是否可以成功在源链上解锁nft
    it("test if user have the nft unlocked on source chain", async function () {
        const newOwner = await nft.ownerOf(0)
        expect(newOwner).to.equal(firstAccount)
    })

})