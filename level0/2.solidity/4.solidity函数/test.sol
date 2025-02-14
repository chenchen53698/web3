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
