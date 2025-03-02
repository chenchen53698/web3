// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
/*
    监听事件并更新用户界面
    一种廉价的存储方式
*/
contract Event {
    // Event declaration 事件声明
    // Up to 3 parameters can be indexed. 最多可以索引 3 个参数。
    // Indexed parameters helps you filter the logs by the indexed parameter 索引参数可帮助您按索引参数过滤日志
    event Log(address indexed sender, string message);
    event AnotherLog();

    function test() public {
        emit Log(msg.sender, "Hello World!");
        emit Log(msg.sender, "Hello EVM!");
        emit AnotherLog();
    }
}