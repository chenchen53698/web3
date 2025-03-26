// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

/**
 * @title CrowdFunding
 * @dev 这是一个众筹合约，允许用户向众筹项目捐款，当达到筹资目标时，资金将转移给受益人。
 */
contract CrowdFunding {
    // 受益人地址，使用 immutable 关键字确保该变量只能在构造函数中初始化
    address public immutable beneficiary;
    // 筹资目标金额，使用 immutable 关键字确保该变量只能在构造函数中初始化
    uint256 public immutable fundingGoal;
    // 当前已筹集到的金额
    uint256 public fundingAmount;
    // 映射，记录每个捐赠者的捐赠金额
    mapping(address => uint256) public funders;
    // 辅助映射，用于标记捐赠者是否已被插入到 fundersKey 数组中
    mapping(address => bool) private fundersInserted;
    // 存储所有捐赠者地址的数组，方便迭代
    address[] public fundersKey;
    // 合约状态，true 表示合约可用，false 表示合约已关闭
    bool public AVAILABLED = true;

    // 事件：当有用户捐赠时触发，记录捐赠者地址和捐赠金额
    event Contribution(address indexed contributor, uint256 amount);
    // 事件：当众筹成功关闭并将资金转移给受益人时触发，记录转移的金额
    event CrowdFundingClosed(uint256 amountTransferred);

    /**
     * @dev 构造函数，在合约部署时执行。
     * @param beneficiary_ 众筹项目的受益人地址。
     * @param goal_ 众筹项目的筹资目标金额。
     */
    constructor(address beneficiary_, uint256 goal_) {
        beneficiary = beneficiary_;
        fundingGoal = goal_;
    }

    /**
     * @dev 捐赠函数，允许用户向众筹项目捐款。
     * 只有在合约可用状态下才能进行捐赠。
     * 如果捐赠金额超过筹资目标，多余的金额将退还。
     */
    function contribute() external payable {
        // 检查合约是否可用
        require(AVAILABLED, "CrowdFunding is closed");

        // 计算潜在的总筹资金额
        uint256 potentialFundingAmount = fundingAmount + msg.value;
        uint256 refundAmount = 0;

        // 如果潜在总筹资金额超过筹资目标
        if (potentialFundingAmount > fundingGoal) {
            // 计算需要退还的金额
            refundAmount = potentialFundingAmount - fundingGoal;
            // 更新捐赠者的捐赠金额
            funders[msg.sender] += (msg.value - refundAmount);
            // 更新当前已筹集到的金额
            fundingAmount += (msg.value - refundAmount);
        } else {
            // 未超过筹资目标，正常更新捐赠者的捐赠金额和当前已筹集到的金额
            funders[msg.sender] += msg.value;
            fundingAmount += msg.value;
        }

        // 如果该捐赠者是首次捐赠
        if (!fundersInserted[msg.sender]) {
            // 标记该捐赠者已被插入到 fundersKey 数组中
            fundersInserted[msg.sender] = true;
            // 将该捐赠者地址添加到 fundersKey 数组中
            fundersKey.push(msg.sender);
        }

        // 触发捐赠事件
        emit Contribution(msg.sender, msg.value - refundAmount);

        // 如果有多余的金额需要退还
        if (refundAmount > 0) {
            // 将多余的金额退还到捐赠者地址
            payable(msg.sender).transfer(refundAmount);
        }
    }

    /**
     * @dev 关闭众筹合约的函数，只有当已筹集金额达到或超过筹资目标时才能关闭。
     * 关闭后，将已筹集的资金转移给受益人，并将合约状态设置为不可用。
     * @return bool 表示众筹是否成功关闭。
     */
    function close() external returns (bool) {
        // 检查已筹集金额是否达到或超过筹资目标
        if (fundingAmount < fundingGoal) {
            return false;
        }

        // 保存当前已筹集的金额
        uint256 amount = fundingAmount;
        // 将已筹集金额重置为 0
        fundingAmount = 0;
        // 将合约状态设置为不可用
        AVAILABLED = false;

        // 将已筹集的资金转移给受益人
        payable(beneficiary).transfer(amount);

        // 触发众筹关闭事件
        emit CrowdFundingClosed(amount);

        return true;
    }

    /**
     * @dev 获取捐赠者地址数组的长度，即捐赠者的数量。
     * @return uint256 捐赠者的数量。
     */
    function fundersLenght() public view returns (uint256) {
        return fundersKey.length;
    }
}