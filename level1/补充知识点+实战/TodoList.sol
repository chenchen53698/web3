// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

/**
 * @title Demo
 * @dev 这是一个简单的待办事项列表合约，允许用户创建、修改和查询待办任务。
 */
contract Demo {
    // 定义待办任务结构体，包含任务名称和完成状态
    struct Todo {
        string name;
        bool isCompleted;
    }

    // 存储所有待办任务的数组
    Todo[] public list;

    // 事件：当创建新任务时触发，记录任务名称
    event TaskCreated(string taskName);
    // 事件：当任务名称被修改时触发，记录任务索引和新名称
    event TaskNameModified(uint256 taskIndex, string newName);
    // 事件：当任务完成状态被修改时触发，记录任务索引和新状态
    event TaskStatusModified(uint256 taskIndex, bool newStatus);

    /**
     * @dev 创建一个新的待办任务。
     * @param name_ 新任务的名称。
     */
    function create(string memory name_) external {
        // 将新任务添加到待办任务列表中
        list.push(Todo({name: name_, isCompleted: false}));
        // 触发任务创建事件
        emit TaskCreated(name_);
    }

    /**
     * @dev 修改指定索引任务的名称（方法1）。
     * 直接修改任务名称，适用于只修改一个属性的情况，相对节省 gas。
     * @param index_ 要修改的任务的索引。
     * @param name_ 新的任务名称。
     */
    function modiName1(uint256 index_, string memory name_) external {
        // 检查索引是否在有效范围内
        require(index_ < list.length, "Invalid task index");
        // 直接修改任务名称
        list[index_].name = name_;
        // 触发任务名称修改事件
        emit TaskNameModified(index_, name_);
    }

    /**
     * @dev 修改指定索引任务的名称（方法2）。
     * 先将任务存储到 storage 变量中，再进行修改，适用于修改多个属性的情况，相对节省 gas。
     * @param index_ 要修改的任务的索引。
     * @param name_ 新的任务名称。
     */
    function modiName2(uint256 index_, string memory name_) external {
        // 检查索引是否在有效范围内
        require(index_ < list.length, "Invalid task index");
        // 将任务存储到 storage 变量中
        Todo storage temp = list[index_];
        // 修改任务名称
        temp.name = name_;
        // 触发任务名称修改事件
        emit TaskNameModified(index_, name_);
    }

    /**
     * @dev 手动指定指定索引任务的完成状态。
     * @param index_ 要修改的任务的索引。
     * @param status_ 新的完成状态。
     */
    function modiStatus1(uint256 index_, bool status_) external {
        // 检查索引是否在有效范围内
        require(index_ < list.length, "Invalid task index");
        // 修改任务完成状态
        list[index_].isCompleted = status_;
        // 触发任务状态修改事件
        emit TaskStatusModified(index_, status_);
    }

    /**
     * @dev 自动切换指定索引任务的完成状态。
     * @param index_ 要修改的任务的索引。
     */
    function modiStatus2(uint256 index_) external {
        // 检查索引是否在有效范围内
        require(index_ < list.length, "Invalid task index");
        // 切换任务完成状态
        list[index_].isCompleted = !list[index_].isCompleted;
        // 获取新的完成状态
        bool newStatus = list[index_].isCompleted;
        // 触发任务状态修改事件
        emit TaskStatusModified(index_, newStatus);
    }

    /**
     * @dev 获取指定索引任务的信息（使用 memory）。
     * 会进行两次拷贝，相对消耗更多 gas。
     * @param index_ 要查询的任务的索引。
     * @return name_ 任务的名称。
     * @return status_ 任务的完成状态。
     */
    function get1(
        uint256 index_
    ) external view returns (string memory name_, bool status_) {
        // 检查索引是否在有效范围内
        require(index_ < list.length, "Invalid task index");
        // 将任务存储到 memory 变量中
        Todo memory temp = list[index_];
        // 返回任务名称和完成状态
        return (temp.name, temp.isCompleted);
    }

    /**
     * @dev 获取指定索引任务的信息（使用 storage）。
     * 只进行一次拷贝，相对消耗更少 gas。 比直接调用都省
     * @param index_ 要查询的任务的索引。
     * @return name_ 任务的名称。
     * @return status_ 任务的完成状态。
     */
    function get2(
        uint256 index_
    ) external view returns (string memory name_, bool status_) {
        // 检查索引是否在有效范围内
        require(index_ < list.length, "Invalid task index");
        // 将任务存储到 storage 变量中
        Todo storage temp = list[index_];
        // 返回任务名称和完成状态
        return (temp.name, temp.isCompleted);
    }
    
}
