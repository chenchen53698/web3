// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/*
    获取、递增和递减此合约中的count。
    注意: count为无符号整数
*/
contract Counter {
    uint256 public count;

    function get() public view returns (uint256) {
        return count;
    }

    function inc() public {
        count += 1;
    }

    function dec() public {
        count -= 1;
    }
}
