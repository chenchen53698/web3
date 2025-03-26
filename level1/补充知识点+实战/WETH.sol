// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title WETH
 * @dev 该合约实现了 WETH 功能，允许用户将以太币（ETH）包装成可交易的 ERC - 20 代币（WETH），
 * 并且可以将 WETH 解包回以太币。
 */
contract WETH {
    // 代币名称
    string public name = "Wrapped Ether";
    // 代币符号
    string public symbol = "WETH";
    // 代币小数位数，与以太币一致为 18 位
    uint8 public decimals = 18;

    // 事件：当用户批准另一个地址（delegateAds）可以从自己的账户转移一定数量的代币时触发
    event Approval(address indexed src,address indexed delegateAds,uint256 amount);
    // 事件：当代币从一个地址（src）转移到另一个地址（toAds）时触发
    event Transfer(address indexed src, address indexed toAds, uint256 amount);
    // 事件：当用户存入以太币并获得相应数量的 WETH 时触发
    event Deposit(address indexed toAds, uint256 amount);
    // 事件：当用户提取 WETH 并换回以太币时触发
    event Withdraw(address indexed src, uint256 amount);

    // 映射：记录每个地址持有的 WETH 余额
    mapping(address => uint256) public balanceOf;
    // 嵌套映射：记录一个地址（src）允许另一个地址（delegateAds）从自己账户转移的 WETH 数量
    mapping(address => mapping(address => uint256)) public allowance;

    /**
     * @dev 用户存入以太币，将其转换为 WETH。
     * 该函数为 payable，意味着可以接收以太币。
     */
    function deposit() public payable {
        // 增加用户的 WETH 余额，增加的数量等于存入的以太币数量
        balanceOf[msg.sender] += msg.value;
        // 触发 Deposit 事件，记录存入操作
        emit Deposit(msg.sender, msg.value);
    }

    /**
     * @dev 用户提取 WETH，将其转换回以太币。
     * @param amount 要提取的 WETH 数量。
     */
    function withdraw(uint256 amount) public {
        // 检查用户的 WETH 余额是否足够
        require(balanceOf[msg.sender] >= amount, "Insufficient balance");
        // 减少用户的 WETH 余额
        balanceOf[msg.sender] -= amount;
        // 将对应数量的以太币转回给用户
        payable(msg.sender).transfer(amount);
        // 触发 Withdraw 事件，记录提取操作
        emit Withdraw(msg.sender, amount);
    }

    /**
     * @dev 获取当前 WETH 的总供应量。
     * 总供应量等于合约当前持有的以太币数量。
     * @return uint256 当前 WETH 的总供应量。
     */
    function totalSupply() public view returns (uint256) {
        return address(this).balance;
    }

    /**
     * @dev 用户批准另一个地址可以从自己的账户转移一定数量的 WETH。
     * @param delegateAds 被批准的地址。
     * @param amount 被批准转移的 WETH 数量。
     * @return bool 表示批准操作是否成功，总是返回 true。
     */
    function approve(address delegateAds,uint256 amount) public returns (bool) {
        // 更新批准额度
        allowance[msg.sender][delegateAds] = amount;
        // 触发 Approval 事件，记录批准操作
        emit Approval(msg.sender, delegateAds, amount);
        return true;
    }

    /**
     * @dev 用户将自己的 WETH 转移到另一个地址。
     * 调用 transferFrom 函数完成转移。
     * @param toAds 接收 WETH 的地址。
     * @param amount 要转移的 WETH 数量。
     * @return bool 表示转移操作是否成功，总是返回 true。
     */
    function transfer(address toAds, uint256 amount) public returns (bool) {
        return transferFrom(msg.sender, toAds, amount);
    }

    /**
     * @dev 从一个地址（src）向另一个地址（toAds）转移 WETH。
     * 如果 src 不是调用者，需要检查调用者是否有足够的批准额度。
     * @param src 转出 WETH 的地址。
     * @param toAds 接收 WETH 的地址。
     * @param amount 要转移的 WETH 数量。
     * @return bool 表示转移操作是否成功，总是返回 true。
     */
    function transferFrom(
        address src,
        address toAds,
        uint256 amount
    ) public returns (bool) {
        // 检查转出地址的 WETH 余额是否足够
        require(balanceOf[src] >= amount, "Insufficient balance");
        if (src != msg.sender) {
            // 如果转出地址不是调用者，检查调用者是否有足够的批准额度
            require(allowance[src][msg.sender] >= amount,"Insufficient allowance");
            // 减少批准额度
            allowance[src][msg.sender] -= amount;
        }
        // 减少转出地址的 WETH 余额
        balanceOf[src] -= amount;
        // 增加接收地址的 WETH 余额
        balanceOf[toAds] += amount;
        // 触发 Transfer 事件，记录转移操作
        emit Transfer(src, toAds, amount);
        return true;
    }

    /**
     * @dev 回退函数，当合约收到没有匹配到任何函数的调用时触发。
     * 这里将其视为存款操作，调用 deposit 函数。
     */
    fallback() external payable {
        deposit();
    }

    /**
     * @dev 接收以太币的函数，当合约收到没有调用任何函数的以太币转账时触发。
     * 这里将其视为存款操作，调用 deposit 函数。
     */
    receive() external payable {
        deposit();
    }
}