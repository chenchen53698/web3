// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/* 
gas limit (max amount of gas you're willing to use for your transaction, set by you)
Gas Limit（您愿意用于交易的最大 Gas 量，由您设置）
block gas limit (max amount of gas allowed in a block, set by the network)
区块 Gas 限制（区块中允许的最大 Gas 量，由网络设置）
*/

contract Gas {
    uint256 public i = 0;
    /*
        Using up all of the gas that you send causes your transaction to fail.
            用完您发送的所有gas会导致交易失败
            原因：以太坊网络使用 Gas 来限制计算资源的使用。如果交易消耗的 Gas 超过了你为其设置的 Gas 限制，交易将被视为失败。

        State changes are undone.
            状态更改会撤消。
            原因：以太坊的设计确保了状态的一致性和原子性。要么所有的操作都成功并被提交，要么没有任何操作被执行。
            
        Gas spent are not refunded.
            已消耗的gas不予退还。
            原因：Gas 费用是用来补偿矿工或验证者处理交易的成本。即使交易失败，矿工仍然花费了资源来处理该交易，因此 Gas 费用不会被退还。
    */
    function forever() public {
        while (true) {
            i+=1;
        }
    }

}