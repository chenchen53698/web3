// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract Immutable {
    /*
        immutable：不可变变量，类似于常量，可以在构造函数中赋值，但之后不可以修改
    */
    address public immutable MY_ADDRESS;
    uint256 public immutable MY_UINT;

    constructor(uint256 _myUint) {
        MY_ADDRESS = msg.sender;
        MY_UINT = _myUint;
    }
}