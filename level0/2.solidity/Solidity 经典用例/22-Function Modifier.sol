// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
/*
    修饰符是可以在函数调用之前和/或之后运行的代码。
    修饰符可用于：
        Restrict access  限制访问
        Validate inputs  验证输入
        Guard against reentrancy hack 防范重入攻击
*/
contract FunctionModifier {
    // We will use these variables to demonstrate how to use modifiers. 我们将使用这些变量来演示如何使用modifiers
    address public owner;
    uint256 public x = 10;
    bool public locked;

    constructor() {
        // Set the transaction sender as the owner of the contract.将交易发送者设置为合约的所有者。
        owner = msg.sender;
    }

    // Modifier to check that the caller is the owner of the contract.修饰符用于检查调用者是否是合约的所有者。
    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        // Underscore is a special character only used inside a function modifier and it tells Solidity to execute the rest of the code.
        // 下划线是一个特殊字符，仅在函数修饰符内使用，它告诉 Solidity 执行其余代码。
        _;
    }

    // Modifiers can take inputs. This modifier checks that the address passed in is not the zero address.
    // 修饰符可以接受输入。此修饰符检查传入的地址是否不是零地址。
    modifier validAddress(address _addr) {
        require(_addr != address(0), "Not valid address");
        _;
    }

    function changeOwner(address _newOwner)public onlyOwner validAddress(_newOwner){
        owner = _newOwner;
    }

    // Modifiers can be called before and / or after a function. 可以在函数之前和/或之后调用修饰符。
    // This modifier prevents a function from being called whileit is still executing.此修饰符可防止函数在执行时被调用。
    modifier noReentrancy() {
        require(!locked, "No reentrancy");

        locked = true;
        _;
        locked = false;
    }

    function decrement(uint256 i) public noReentrancy {
        x -= i;

        if (i > 1) {
            decrement(i - 1);
        }
    }
}