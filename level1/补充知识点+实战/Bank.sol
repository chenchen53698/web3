// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title Bank.sol
 * @dev 这是一个合约，允许用户向合约存款，只有合约所有者可以提取所有余额。
 */
contract Bank {
    // 状态变量，用于存储合约所有者的地址，使用 immutable 关键字确保该变量只能在构造函数中初始化
    address public immutable owner;

    // 事件：当有用户向合约存款时触发，记录存款者的地址和存款金额
    event Deposit(address indexed _ads, uint256 amount);
    // 事件：当合约所有者提取所有余额时触发，记录提取的金额
    event Withdraw(uint256 amount);

    /**
     * @dev 构造函数，在合约部署时执行。
     * 部署合约时可以选择向合约发送以太币（使用 payable 关键字）。
     * 将合约部署者的地址赋值给 owner 变量。
     */
    constructor() payable {
        owner = msg.sender;
    }

    /**
     * @dev 特殊的接收以太币函数，当合约收到没有调用任何函数的以太币转账时触发。
     * 触发 Deposit 事件，记录存款者的地址和存款金额。
     */
    receive() external payable {
        emit Deposit(msg.sender, msg.value);
    }

    /**
     * @dev 提取合约所有余额的函数，只有合约所有者可以调用。
     * 检查调用者是否为合约所有者，如果不是则抛出错误信息 "Not Owner"。
     * 检查合约中是否有金钱，如果没有则抛出错误信息 "No money"。
     * 触发 Withdraw 事件，记录提取的金额。
     * 使用 selfdestruct 函数销毁合约，并将合约的所有余额发送给调用者。
     * selfdestruct在6版本后被禁用
     */
    function withdraw() external {
        require(msg.sender == owner, "Not Owner");
        require(address(this).balance != 0, "No money");
        emit Withdraw(address(this).balance);
        // selfdestruct(payable(msg.sender));
        payable(msg.sender).transfer(address(this).balance);
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