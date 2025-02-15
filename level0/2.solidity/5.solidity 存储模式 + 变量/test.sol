// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract HelloWorld {
    string strVar = "Hello World"; //状态变量

    //读取
    function sayHello() public view returns (string memory) {
        return addinfo(strVar);
    }

    //修改
    function setHelloWorld(string memory newString) public {
        strVar = newString; // 使用状态变量 ，并在函数内给它辅助
    }

    //计算
    function addinfo(
        string memory helloWorldStr
    ) internal pure returns (string memory) {
        // return uint a = 1; // 局部变量
        return string.concat(helloWorldStr, " FORM Ceepe's contract.");
    }
}

/*
        存储模式:只针对于存储结构的（或者说复杂数据类型），基础数据类型是不需要的(编译器会帮助你判断的)，string的话就是byte的动态数组
        storage：会在区块链上永久存储，即使交易被挖矿并添加到区块链后，数据也会一直保留，storage是昂贵的，因为它需要使用区块链上的磁盘空间，所有状态变量都存储在storage中。
        memory：数据在临时内存中存储，当前函数执行完毕后，这部分数据会被清除，不会被永久写入区块链，function中的局部变量默认在memory中。
        calldata：数据在临时内存中存储，用于函数参数，特别是external函数，这类数据只读且只在函数调用期间存在。
        stack
        codes
        logs

        同一数据位置的赋值：通常只增加一个引用，例如从 memory 到 memory，多个变量指向同一个数据。
        跨数据位置的赋值：例如从 memory 到 storage，则会创建独立的拷贝。

        Solidity 中的变量:
            状态变量:如果一个变量是状态变量，那么它的值将永久保存在合约存储空间中。
            局部变量:是仅限于在函数执行过程中有效的变量，函数执行完毕后，变量就不再受任何影响。函数参数也是局部变量。
            全局变量:它们是全局工作区中存在的特殊变量，提供有关区块链和交易属性的信息。
            eg:
                blockhash(uint blockNumber) returns (bytes32) 给定区块的哈希值 – 只适用于 256 最近区块, 不包含当前区块
                block.coinbase (address payable) 当前区块矿工的地址
                block.difficulty (uint) 当前区块的难度
                block.gaslimit (uint) 当前区块的 gaslimit
                block.number (uint) 当前区块的 number
                block.timestamp (uint) 当前区块的时间戳，为 unix 纪元以来的秒
                gasleft() returns (uint256) 剩余 gas
                msg.data (bytes calldata) 完成 calldata
                msg.sender (address payable) 消息发送者 (当前 caller)
                msg.sig (bytes4) calldata 的前四个字节 (function identifier)
                msg.value (uint) 当前消息的 wei 值
                now (uint) 当前块的时间戳
                tx.gasprice (uint) 交易的 gas 价格
                tx.origin (address payable) 交易的发送方
        
*/
