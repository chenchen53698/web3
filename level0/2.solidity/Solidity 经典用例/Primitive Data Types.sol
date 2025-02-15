// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./test.sol";

contract Primitives {
    /*
        bool: 布尔类型,不能用0或1代替false或true
    */
    bool public flag = true;
    /*
        uint: 无符号整数
        uint8:[0, 2 ** 8 - 1)
        uint16:[0, 2 ** 16 - 1)
        ...
        uint后面不跟数字默认为uint256
    */
    uint8 public a = 255;
    uint256 public b = 3151531245151235;
    /*
        int: 整数
        int8:[-2 ** 7, 2 ** 7 - 1)
        int16:[-2 ** 15, 2 ** 15 - 1)
        ...
        int后面不跟数字默认为int256
    */
    int8 public c = -128;
    int8 public d = 127;
    /*
        type(C).name (string): 合约的名称
        type(C).creationCode (bytes memory): 合约的创建字节码
        type(C).runtimeCode (bytes memory): 合约的运行时字节码
        type(I).interfaceId (bytes4): 包含给定接口的 EIP-165 接口标识符  ??
        type(T).min (T): 所在整型 T 的最小值
        type(T).max (T): 所在整型 T 的最大值
    */
    string public contractName = type(HelloWorld).name;
    bytes public creationCode = type(HelloWorld).creationCode;
    bytes public runtimeCode = type(HelloWorld).runtimeCode;
    int8 public minInt = int8(type(int256).min);
    int256 public maxInt = type(int8).max;
    /*
        bytes:  字节
        最大32 一般用于存储字符串(提前知道存储的字节大小比string占用更小)
        bytes（后面不加数字）区别于加数字的 它相当于 byte[] 可用于存储多个byte的数组
    */
    bytes1 public b1 = 0xb5;
    bytes1 public b2 = 0x56;
    bytes1 public b3 = '1';

    /*
        默认值
        bool: false
        uint: 0
        int: 0
        address: 0x0000000000000000000000000000000000000000
    */
    bool public defaultBool;
    uint256 public defaultUint;
    int256 public defaultInt;
    address public defaultAddr;
}