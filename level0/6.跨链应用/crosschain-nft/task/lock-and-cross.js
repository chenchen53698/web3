const { task } = require("hardhat/config")
const { networkConfig } = require("../helper-hardhat-config")
/*
    .addParam  手动添加参数
    .addOptionalParam  可选择的手动or默认
*/
task("lock-and-cross")
    .addParam("tokenid", "tokenId to be locked and crossed")//这里小写是因为cmd tokenId命令行内是token-id，麻烦
    .addOptionalParam("chainselector", "chain selector of destination chain")
    .addOptionalParam("receiver", "receiver in the destination chain")
    .setAction(async (taskArgs, hre) => {
        const tokenId = taskArgs.tokenid
        const { firstAccount } = await getNamedAccounts()
        let chainselector
        let receiver

        if (taskArgs.chainselector) {
            chainselector = taskArgs.chainselector
        } else {
            chainselector = networkConfig[network.config.chainId].companionChainSelector
        }
        console.log(`destination chain selector is ${chainselector}`)
        if (taskArgs.receiver) {
            receiver = taskArgs.receiver
        } else {
            //获取xxx网络下的xxx合约
            const nftBurnAndMint = await hre.companionNetworks["destChain"].deployments.get("NFTPoolBurnAndMint")
            receiver = nftBurnAndMint.address
        }
        console.log(`NFTPoolBurnAndMint address on destination chain is ${receiver}`)

        // transfer 10 LINK token from deployer to pool
        const linkTokenAddr = networkConfig[network.config.chainId].linkToken//ccip用到的网络的linkToken
        const linkToken = await ethers.getContractAt("LinkToken", linkTokenAddr)
        const nftPoolLockAndRelease = await ethers.getContract("NFTPoolLockAndRelease", firstAccount)//转移的合约地址
        const transferTx = await linkToken.transfer(nftPoolLockAndRelease.target, ethers.parseEther("10"))
        await transferTx.wait(6)
        const balanceAfter = await linkToken.balanceOf(nftPoolLockAndRelease.target)
        console.log(`balance after: ${balanceAfter}`)

        // approve the pool have the permision to transfer deployer's token
        const nft = await ethers.getContract("MyToken", firstAccount)
        await nft.approve(nftPoolLockAndRelease.target, tokenId)
        console.log("approve successfully")

        // ccip send
        console.log(`${tokenId}, ${firstAccount}, ${chainselector}, ${receiver}`)
        const lockAndCrossTx = await nftPoolLockAndRelease.lockAndSendNFT(
            tokenId, 
            firstAccount, 
            chainselector, 
            receiver
        )

        // provide t   获取哈希可在https://ccip.chain.link/中查看 等待时间很长，
        console.log(`NFT locked and crossed, transaction hash is ${lockAndCrossTx.hash}`)
    })

    module.exports = {}