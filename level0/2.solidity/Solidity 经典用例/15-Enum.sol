// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/*
    枚举是一种用户定义的类型，用于表示一组有限的常量值。
    枚举值默认从 0 开始递增。
    枚举可以提高代码的可读性和可维护性。
    适用于表示状态、选项或模式等场景。
*/
contract EnumEG {
    // Enum representing shipping status 表示运输状态的枚举
    enum Status {
        Pending,
        Shipped,
        Accepted,
        Rejected,
        Canceled
    }

    // Default value is the first element listed in definition of the type, in this case "Pending"
    // 默认值是类型定义中列出的第一个元素，在本例中为 “Pending”
    Status public status;

    // Returns uint 返回值
    // Pending  - 0
    // Shipped  - 1
    // Accepted - 2
    // Rejected - 3
    // Canceled - 4
    function get() public view returns (Status) {
        return status;
    }

    // Update status by passing uint into input 通过输入值来更新状态 本案例中枚举值为0,1,2,3,4
    function set(Status _status) public {
        status = _status;
    }

    // You can update to a specific enum like this 您可以像这样更新到特定的枚举
    function cancel() public {
        status = Status.Canceled;
    }

    // delete resets the enum to its first value, 0   delete 将枚举重置为其第一个值 0
    function reset() public {
        delete status;
    }
}
