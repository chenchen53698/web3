// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
/*
    该合约是募集资金的合约，通过函数来接受funder的ETH.
    1.创建一个收款函数
    2.记录投资人并且查看(转换ETH/USD)
    3.在锁定期内，达到目标值，生产商可以提款
    4.在锁定期内，没有达到目标值，投资人可以退款
*/

// solidty中并没有小数,浮点数的数据类型 使用1*10^1这种方式表达

contract FundMe{
    mapping (address=>uint256 ) public fundersToAmount;
    uint256 constant MINIMUM_VALUE = 100 * 10**18;//最小值1eth ==>最小值100USD
    uint256 constant TARGET = 1000 * 10**18;//目标值 constant 使变量变常量，使值无法被修改，一般名字使用大写字母
    AggregatorV3Interface internal dataFeed;//合约内部的函数才能调用
    address public owner;
    constructor(){//在合约部署时进行一次调用，并且以后再也不会调用，用于初始化合约状态。
        //sepolia testnet(测试网) ETH / USD转换比价格地址
        dataFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        owner =msg.sender;//消息发送者
    }
    /*
        1.创建一个收款函数
        external--只能从合约外部调用，内部需要关键字this
        payable -- 声明函数可以接受链上的原生通证
    */
    function fund() external payable {
        //Solidity 抛出异常的方法
        require(convertEthToUsd(msg.value) >= MINIMUM_VALUE,"Send more ETH");
        /*
            2.记录投资人并且查看
            msg.value (uint) 当前消息的 wei 值
            msg.sender (address payable) 消息发送者 (当前 caller)
        */
        fundersToAmount[msg.sender] = msg.value;
    }
    //获取ETH价格
    function getChainlinkDataFeedLatestAnswer() public view returns (int) {
        // prettier-ignore
        (
            /* uint80 roundID */,
            int answer,
            /*uint startedAt*/,
            /*uint timeStamp*/,
            /*uint80 answeredInRound*/
        ) = dataFeed.latestRoundData();
        return answer;
    }

    //转化
    function convertEthToUsd(uint256 ethAmount) internal view returns (uint256){
        // (ETH amount) * (ETH price) = (ETH value)
        //显示转换 
        uint256 ethPrice = uint256(getChainlinkDataFeedLatestAnswer());
        // chinlink预言机对于获取到的USD价钱扩大了10**8,所以在将ETH转换为USD时，需要除10**8
        return ethAmount * ethPrice /(10 **8);
    }

    // 3.在锁定期内，达到目标值，生产商可以提款
    function getFund() external {
        //显示转换 this--这个合约,获取当前合约地址
        //address.blance  属性获取地址的以太坊余额（单位为 wei）
        require(convertEthToUsd(address(this).balance) >= TARGET,"Target is not reached");
        require(msg.sender == owner,"this function can only bi called by owner");
        
    }
    //转移所有权
    function transferOwnership(address newOwner) public{
        require(msg.sender == owner,"this function can only bi called by owner");
        owner = newOwner;
    }
} 
 