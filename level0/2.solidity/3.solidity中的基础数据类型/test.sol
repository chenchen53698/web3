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
    字节 --- bytes 最大32 一般用于存储字符串(提前知道存储的字节大小比string占用更小)
         --- string 动态分配的byte
         --- bytes（后面不加数字）区别于加数字的 它相当于 byte[] 可用于存储多个byte的数组
    地址 --- address

**/
