// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract HelloWorld{
    string strVar = 'Hello World';
    //读取
    function sayHello() public view returns(string memory){
        return addinfo(strVar);
    }
    //修改
    function setHelloWorld(string memory newString) public {
        strVar = newString;
    }
    //计算
    function addinfo(string memory helloWorldStr) internal pure returns(string memory){
        return string.concat(helloWorldStr," FORM Ceepe's contract.");
    }
}

/*
    函数
    function 函数名(< 参数类型 > < 参数名 >) < 可见性 > < 状态可变性 > [returns(< 返回类型 >)] {
        // 函数体
    }
    函数可以包含输入参数、输出参数、可见性修饰符、状态可变性修饰符和返回类型。
    函数可见性修饰符：
        private （私有）：
            只能在定义该函数的合约内部调用。
        internal （内部）：
            可在定义该函数的合约内部调用，也可从继承该合约的子合约中调用。
        external （外部）：
            只能从合约外部调用。如果需要从合约内部调用，必须使用this关键字。
        public （公开）：
            可以从任何地方调用，包括合约内部、继承合约和合约外部。
    状态可变性修饰符:
        view：
            声明函数只能读取状态变量，不能修改状态。
        pure：
            声明函数既不能读取也不能修改状态变量，通常用于执行纯计算。
        payable：
            声明函数可以接受以太币，如果没有该修饰符，函数将拒绝任何发送到它的以太币。

*/
/*
        存储模式:只针对于存储结构的（或者说复杂数据类型），基础数据类型是不需要的(编译器会帮助你判断的)，string的话就是byte的动态数组
        storage：会在区块链上永久存储，即使交易被挖矿并添加到区块链后，数据也会一直保留，storage是昂贵的，因为它需要使用区块链上的磁盘空间，所有状态变量都存储在storage中。
        memory：数据在临时内存中存储，当前函数执行完毕后，这部分数据会被清除，不会被永久写入区块链，function中的局部变量默认在memory中。
        calldata：数据在临时内存中存储，用于函数参数，特别是external函数，这类数据只读且只在函数调用期间存在。
        stack
        codes
        logs
*/
