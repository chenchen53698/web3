// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract Array {
    // Several ways to initialize an array  初始化数组的几种方法
    uint256[] public arr;
    uint256[] public arr2 = [1, 2, 3];
    // Fixed sized array, all elements initialize to 0  固定大小数组，所有元素初始化为 0
    uint256[10] public myFixedSizeArr;

    function get(uint256 i) public view returns (uint256) {
        return arr[i];
    }

    // Solidity can return the entire array. Solidity 可以返回整个数组。
    // But this function should be avoided for arrays that can grow indefinitely in length. 但是对于长度可以无限增长的数组，应该避免使用该函数。
    function getArr() public view returns (uint256[] memory) {
        return arr;
    }

    function push(uint256 i) public {
        // Append to array 追加到数组
        // This will increase the array length by 1. 这将使数组长度增加 1。
        arr.push(i);
    }

    function pop() public {
        // Remove last element from array
        // This will decrease the array length by 1
        arr.pop();
    }

    function getLength() public view returns (uint256) {
        return arr.length;
    }

    function remove(uint256 index) public {
        // Delete does not change the array length. Delete 不会更改数组长度。
        // It resets the value at index to it's default value,in this case 0 它将索引处的值重置为其默认值，在本例中为 0
        delete arr[index];
    }

    function examples() external {
        // create array in memory, only fixed size can be created 只能创建固定大小
        uint256[] memory a = new uint256[](5);
    }
}