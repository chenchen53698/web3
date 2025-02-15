// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract HelloWorld{
    bool boolVar_1 = true;
    bool boolVar_2= false;

    uint8 uintVar_1 = 255;
    uint256 uintVar_2 = 25566666666666666;

    int256 intVar = -1;

    bytes12 bytesVar_1 = 'Hello World';
    string bytesVar_2 = 'Hello World';

    address addrVar = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;
    //对外暴露名字为greet的字符串
    string public greet = "Hello World!";
}

/**
    contract(合同)
    基础数据类型：
    布尔类型 --- bool (没有0，1代表false,true)
    无符号整数 --- uint (unsigned integer)
        后面还能加数字 代表它能存储的整形数据最大值
        uint 默认等于 uint256 默认写法(不要这么写) 
        eg: uint8 === 0-(2^8 -1) === 0-255 
    整数 --- int (可以写负数)
        整数除 0 会抛出异常。
        整数除法总是截断的，但如果运算符是字面量（字面量稍后讲)，则不会截断。
        eg:10/100=0.1但是在solidity中= 0
    字节 --- bytes 最大32 一般用于存储字符串(提前知道存储的字节大小比string占用更小)
         --- string 动态分配的byte
         --- bytes（后面不加数字）区别于加数字的 它相当于 byte[] 可用于存储多个byte的数组
    地址 --- address
        是一个 20 字节（160 位）的值，代表以太坊区块链上的一个账户地址。
    合约类型  
        每一个合约，合约本身也是一个数据类型， 称为合约类型
        eg:7.solidity 工厂模式
    引用类型
        在 Solidity 中，引用类型包括结构体（struct）、数组（array）和映射（mapping）。
        与值类型不同，引用类型在赋值时不会直接复制值，而是创建一个指向原数据的引用。这样可以避免对大型数据的多次拷贝，节省 Gas。
        
**/
