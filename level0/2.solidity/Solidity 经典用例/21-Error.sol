// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
/*
    require用于在执行之前验证输入和条件。
    revert与require类似，具体见下方代码。
    assert用于检查代码是否永远不应为假。断言失败可能意味着存在错误。
    使用自定义错误来节省 gas。
*/
contract Error {
    function testRequire(uint256 _i) public pure {
        // Require should be used to validate conditions such as:Require 应该用来验证以下条件：
        // - inputs
        // - conditions before execution 执行前的条件
        // - return values from calls to other functions 调用其他函数的返回值
        require(_i > 10, "Input must be greater than 10");
    }

    function testRevert(uint256 _i) public pure {
        // Revert is useful when the condition to check is complex.当要检查的条件很复杂时，Revert 非常有用。
        // This code does the exact same thing as the example above 此代码的作用与上面的例子完全相同
        if (_i <= 10) {
            revert("Input must be greater than 10");
        }
    }

    uint256 public num;

    function testAssert() public view {
        // Assert should only be used to test for internal errors,and to check invariants.Assert 应该只用于测试内部错误和检查不变量。

        // Here we assert that num is always equal to 0 since it is impossible to update the value of num
        // 在这里，我们断言 num 始终等于 0，因为无法更新 num 的值
        assert(num == 0);
    }

    // custom error 自定义错误
    error InsufficientBalance(uint256 balance, uint256 withdrawAmount);

    function testCustomError(uint256 _withdrawAmount) public view {
        uint256 bal = address(this).balance;
        if (bal < _withdrawAmount) {
            revert InsufficientBalance({
                balance: bal,
                withdrawAmount: _withdrawAmount
            });
        }
    }
}

contract Account {
    uint256 public balance;
    uint256 public constant MAX_UINT = 2 ** 256 - 1;

    function deposit(uint256 _amount) public {
        uint256 oldBalance = balance;
        uint256 newBalance = balance + _amount;

        // balance + _amount does not overflow if balance + _amount >= balance
        require(newBalance >= oldBalance, "Overflow");

        balance = newBalance;

        assert(balance >= oldBalance);
    }

    function withdraw(uint256 _amount) public {
        uint256 oldBalance = balance;

        // balance - _amount does not underflow if balance >= _amount
        require(balance >= _amount, "Underflow");

        if (balance < _amount) {
            revert("Underflow");
        }

        balance -= _amount;

        assert(balance <= oldBalance);
    }
}