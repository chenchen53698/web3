// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/*
    该合约是募集资金的合约，通过函数来接受funder的ETH.
    1.创建一个收款函数
    2.记录投资人并且查看
    3.在锁定期内，达到目标值，生产商可以提款
    4.在锁定期内，没有达到目标值，投资人可以退款
*/

// solidty中并没有小数,浮点数的数据类型 使用1*10^1这种方式表达

contract FundMe{
    
    mapping (address=>uint256 ) public fundersToAmount;

    uint256 MINIMUM_VALUE = 1 * 10**18;//最小值1eth
    /*
        1.创建一个收款函数
        external--只能从合约外部调用，内部需要关键字this
        payable -- 声明函数可以接受链上的原生通证
    */
    function fund() external payable {
        //Solidity 抛出异常的方法
        require(msg.value >= MINIMUM_VALUE,"Send more ETH");
        /*
            2.记录投资人并且查看
            msg.value (uint) 当前消息的 wei 值
            msg.sender (address payable) 消息发送者 (当前 caller)
        */
        fundersToAmount[msg.sender] = msg.value;
    }

} 
