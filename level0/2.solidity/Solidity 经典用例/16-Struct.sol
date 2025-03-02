// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
/*
    您可以通过创建struct来定义自己的类型。
    结构体可以在合约之外声明并导入到另一个合约中。
*/
contract Todos {
    struct Todo {
        string text;
        bool completed;
    }

    // An array of 'Todo' structs “Todo”结构数组
    Todo[] public todos;

    function create(string calldata _text) public {
        // 3 ways to initialize a struct
        // - calling it like a function
        todos.push(Todo(_text, false));

        // key value mapping
        todos.push(Todo({text: _text, completed: false}));

        // initialize an empty struct and then update it
        Todo memory todo;
        todo.text = _text;
        // todo.completed initialized to false
        todos.push(todo);
    }

    // Solidity automatically created a getter for 'todos' so you don't actually need this function.
    // Solidity 自动为“todos”创建了一个 getter，因此您实际上并不需要此功能。
    function get(uint256 _index)
        public
        view
        returns (string memory text, bool completed)
    {
        Todo storage todo = todos[_index];
        return (todo.text, todo.completed);
    }

    // update text
    function updateText(uint256 _index, string calldata _text) public {
        Todo storage todo = todos[_index];
        todo.text = _text;
    }

    // update completed
    function toggleCompleted(uint256 _index) public {
        Todo storage todo = todos[_index];
        todo.completed = !todo.completed;
    }
}