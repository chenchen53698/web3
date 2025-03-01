// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract EthUnits {

    uint256 public oneWei = 1 wei;
    // 由于 oneWei 被初始化为 1 wei，而 1 wei 的值在数值上等于 1，因此这个表达式的结果为 true。
    bool public isOneWei = ( oneWei == 1 );

    uint256 public oneGwei = 1 gwei;
    // 1 gwei = 10^9 gwei  = 1,000,000,000 wei
    bool public isOneGwei = ( oneGwei == 1e9);

    uint256 public oneETH = 1 ether;
    // 1 eth = 10^18 wei
    bool public isOneETH = (oneETH == 1e18);


}