// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title MultiSigWallet
 * @dev 这是一个多重签名钱包合约，需要多个所有者的批准才能执行交易，增强了资金的安全性。
 */
contract MultiSigWallet {
    // 存储所有钱包所有者的地址数组
    address[] public owners;
    // 映射，用于快速检查某个地址是否为钱包所有者
    mapping(address => bool) public isOwner;
    // 执行交易所需的最小批准数
    uint256 public required;

    // 交易结构体，包含交易的目标地址、转账金额、附带数据以及交易是否已执行的标志
    struct Transaction {
        address to;
        uint256 value;
        bytes data;
        bool executed;
    }

    // 存储所有待执行交易的数组
    Transaction[] public transactions;
    // 嵌套映射，记录每个交易的批准情况，即某个所有者是否批准了某个交易
    mapping(uint256 => mapping(address => bool)) public approved;

    // 事件：当有以太币存入钱包时触发
    event Deposit(address indexed sender, uint256 amount);
    // 事件：当提交一个新的交易时触发
    event Submit(uint256 indexed txId);
    // 事件：当某个所有者批准一个交易时触发
    event Approve(address indexed owner, uint256 indexed txId);
    // 事件：当某个所有者撤销对一个交易的批准时触发
    event Revoke(address indexed owner, uint256 indexed txId);
    // 事件：当一个交易被成功执行时触发
    event Execute(uint256 indexed txId);

    // 特殊的接收以太币函数，当合约收到没有调用任何函数的以太币转账时触发
    receive() external payable {
        emit Deposit(msg.sender, msg.value);
    }

    // 函数修改器：确保调用者是钱包所有者
    modifier onlyOwner() {
        require(isOwner[msg.sender], "not owner");
        _;
    }

    // 函数修改器：确保指定的交易 ID 对应的交易存在
    modifier txExists(uint256 _txId) {
        require(_txId < transactions.length, "tx doesn't exist");
        _;
    }

    // 函数修改器：确保调用者还没有批准指定的交易
    modifier notApproved(uint256 _txId) {
        require(!approved[_txId][msg.sender], "tx already approved");
        _;
    }

    // 函数修改器：确保指定的交易还没有被执行
    modifier notExecuted(uint256 _txId) {
        require(!transactions[_txId].executed, "tx is executed");
        _;
    }

    /**
     * @dev 构造函数，在合约部署时执行，用于初始化钱包的所有者和所需批准数。
     * @param _owners 钱包所有者的地址数组。
     * @param _required 执行交易所需的最小批准数。
     */
    constructor(address[] memory _owners, uint256 _required) {
        // 确保至少有一个所有者
        require(_owners.length > 0, "owner required");
        // 确保所需批准数在合理范围内
        require(
            _required > 0 && _required <= _owners.length,
            "invalid required number of owners"
        );

        for (uint256 i = 0; i < _owners.length; i++) {
            address owner = _owners[i];
            // 确保所有者地址不是零地址
            require(owner != address(0), "invalid owner");
            // 确保所有者地址不重复
            require(!isOwner[owner], "owner is not unique");
            isOwner[owner] = true;
            owners.push(owner);
        }
        required = _required;
    }

    /**
     * @dev 获取钱包当前的以太币余额。
     * @return balance 钱包的当前以太币余额。
     */
    function getBalance() external view returns (uint256 balance) {
        return address(this).balance;
    }

    /**
     * @dev 提交一个新的交易。
     * @param _to 交易的目标地址。
     * @param _value 交易的转账金额。
     * @param _data 交易附带的数据。
     * @return txId 新提交交易的 ID。
     */
    function submit(
        address _to,
        uint256 _value,
        bytes calldata _data
    ) external onlyOwner returns (uint256 txId) {
        // 创建一个新的交易并添加到交易数组中
        transactions.push(
            Transaction({
                to: _to,
                value: _value,
                data: _data,
                executed: false
            })
        );
        // 获取新交易的 ID
        txId = transactions.length - 1;
        // 触发提交交易事件
        emit Submit(txId);
        return txId;
    }

    /**
     * @dev 某个所有者批准一个待执行的交易。
     * @param _txId 要批准的交易的 ID。
     */
    function approve(
        uint256 _txId
    ) external onlyOwner txExists(_txId) notApproved(_txId) notExecuted(_txId) {
        // 标记该所有者批准了该交易
        approved[_txId][msg.sender] = true;
        // 触发批准交易事件
        emit Approve(msg.sender, _txId);
    }

    /**
     * @dev 执行一个已获得足够批准数的交易。
     * @param _txId 要执行的交易的 ID。
     */
    function execute(
        uint256 _txId
    ) external onlyOwner txExists(_txId) notExecuted(_txId) {
        // 确保该交易已获得足够的批准数
        require(getApprovalCount(_txId) >= required, "approvals < required");
        // 获取要执行的交易
        Transaction storage transaction = transactions[_txId];
        // 标记该交易已执行
        transaction.executed = true;
        // 执行交易
        (bool success, ) = transaction.to.call{value: transaction.value}(
            transaction.data
        );
        // 确保交易执行成功
        require(success, "tx failed");
        // 触发执行交易事件
        emit Execute(_txId);
    }

    /**
     * @dev 获取某个交易的批准数量。
     * @param _txId 要查询的交易的 ID。
     * @return count 该交易的批准数量。
     */
    function getApprovalCount(
        uint256 _txId
    ) public view returns (uint256 count) {
        for (uint256 i = 0; i < owners.length; i++) {
            if (approved[_txId][owners[i]]) {
                count++;
            }
        }
        return count;
    }

    /**
     * @dev 某个所有者撤销对一个已批准交易的批准。
     * @param _txId 要撤销批准的交易的 ID。
     */
    function revoke(
        uint256 _txId
    ) external onlyOwner txExists(_txId) notExecuted(_txId) {
        // 确保该所有者已经批准了该交易
        require(approved[_txId][msg.sender], "tx not approved");
        // 撤销该所有者对该交易的批准
        approved[_txId][msg.sender] = false;
        // 触发撤销批准事件
        emit Revoke(msg.sender, _txId);
    }
}