// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract Variables {
    /*
        状态变量：存储在区块链上，在函数外面声明
    */
    string public text = "Hello";
    uint256 public num = 123;
    /*
        全局变量：提供有关区块链的相关信息
    */
    uint256 timestamp = block.timestamp; // Current block timestamp
    address sender = msg.sender; // address of the caller

    function doSomething() public pure returns (uint256) {
        /*
            局部变量：只在函数中使用
        */
        uint256 aa = 456;
        return aa;
    }
}
