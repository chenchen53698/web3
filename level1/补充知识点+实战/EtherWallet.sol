// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title EtherWallet
 * @dev 这是一个简单的以太币钱包合约，允许合约所有者接收和提取以太币。
 */
contract EtherWallet {
    // 合约所有者的地址，使用 payable 修饰以便可以接收以太币，immutable 确保该地址在合约部署后不可更改
    address payable public immutable owner;

    // 事件：用于记录合约的操作信息，包括函数名、发送者地址、转账金额和数据
    event Log(string funName, address from, uint256 value, bytes data);

    /**
     * @dev 构造函数，在合约部署时执行。
     * 部署合约时可以选择向合约发送以太币（使用 payable 关键字）。
     * 将合约部署者的地址赋值给 owner 变量。
     */
    constructor() payable{
        owner = payable(msg.sender);
    }

    /**
     * @dev 特殊的接收以太币函数，当合约收到没有调用任何函数的以太币转账时触发。
     * 触发 Log 事件，记录接收操作的相关信息。
     */
    receive() external payable {
        emit Log("receive", msg.sender, msg.value, "");
    }

    /**
     * @dev 提取 100 单位以太币的函数，只有合约所有者可以调用。
     * 使用 transfer 方法将 100 单位以太币从合约转移到调用者地址。
     * transfer 方法会自动处理转账失败的情况（如 gas 不足或接收者拒绝），并回滚交易。
     */
    function withdraw1() external {
        // 检查调用者是否为合约所有者
        require(msg.sender == owner, "Not owner");
        // 将 100 单位以太币从合约转移到调用者地址
        // payable(msg.sender).transfer(100); == owner.transfer(100);
        payable(msg.sender).transfer(100);
        // 触发 Log 事件，记录 withdraw1 操作的相关信息
        emit Log("withdraw1", address(this), 100, "");
    }

    /**
     * @dev 尝试提取 200 单位以太币的函数，只有合约所有者可以调用。
     * 使用 send 方法将 200 单位以太币从合约转移到调用者地址。
     * send 方法返回一个布尔值表示转账是否成功，不会自动回滚交易。
     */
    function withdraw2() external {
        // 检查调用者是否为合约所有者
        require(msg.sender == owner, "Not owner");
        // 尝试将 200 单位以太币从合约转移到调用者地址
        bool success = payable(msg.sender).send(200);
        // 检查转账是否成功
        require(success, "Send Failed");
        // 触发 Log 事件，记录 withdraw2 操作的相关信息
        emit Log("withdraw2", address(this), 200, "");
    }

    /**
     * @dev 提取合约所有余额的函数，只有合约所有者可以调用。
     * 使用 call 方法将合约的所有余额转移到调用者地址。
     * call 方法提供了更多的灵活性，但需要手动处理转账结果。
     */
    function withdraw3() external {
        // 检查调用者是否为合约所有者
        require(msg.sender == owner, "Not owner");
        // 获取合约的当前余额
        uint256 balance = address(this).balance;
        // 尝试将合约的所有余额转移到调用者地址
        (bool success, ) = msg.sender.call{value: balance}("");
        // 检查转账是否成功
        require(success, "Call Failed");
        // 触发 Log 事件，记录 withdraw3 操作的相关信息
        emit Log("withdraw3", address(this), balance, "");
    }

    /**
     * @dev 获取合约当前余额的函数。
     * 该函数是 view 类型，意味着它不会修改合约的状态。
     * @return uint256 合约当前的以太币余额。
     */
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}