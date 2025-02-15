// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract HelloWorld {
    string public greet = "Hello World!"; //可见性修饰符控制函数和状态变量的访问权限。
    function returnAny() public view returns(string memory){//string为特殊数组属于引入类型，需指定存储模式
        return  greet;
    }
}