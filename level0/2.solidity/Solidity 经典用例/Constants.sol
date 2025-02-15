// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract Constants {
    /*
        常量是不可修改的变量，值是硬编码的，通常可以节省gas成本
    */
    address public constant MY_ADDRESS = 0x777788889999AaAAbBbbCcccddDdeeeEfFFfCcCc;
    uint256 public constant MY_UINT = 123;
}