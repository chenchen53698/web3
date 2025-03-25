### **NatSpec 注释规范**

#### 1. **基本结构**

```
/**
 * 函数功能的简要描述
 * @param <参数名> 参数说明
 * @return <返回值名> 返回值说明
 * @notice 给终端用户的重要提示（会显示在交易确认弹窗中）
 * @dev 给开发者的详细技术说明（不会显示给用户）
 */
```

#### 2. **你的示例解析**

```
/**
 * 计算无符号整数数组的总和
 * @param numbers 无符号整数数组，长度任意
 * @return total 数组元素的总和
 */
function sum(uint[] memory numbers) public pure returns (uint total) {
    total = 0;
    for (uint i = 0; i < numbers.length; i++) {
        total += numbers[i];
    }
}
```

- **简要描述**：首行说明函数功能。
- `@param`：定义参数名和用途。
- `@return`：定义返回值名和含义。

------

### **3. 完整 NatSpec 标签列表**

| 标签          | 用途                                |
| :------------ | :---------------------------------- |
| `@title`      | 合约的标题（用于合约级注释）        |
| `@author`     | 作者信息                            |
| `@notice`     | 用户可见的说明（如安全警告）        |
| `@dev`        | 开发者专用的技术细节                |
| `@param`      | 函数参数说明                        |
| `@return`     | 函数返回值说明                      |
| `@inheritdoc` | 继承父合约的文档                    |
| `@custom:xxx` | 自定义标签（如 `@custom:security`） |

------

### **4. 合约级注释示例**

```
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title 数学工具库
 * @author Alice
 * @notice 提供基础的数学运算功能
 * @dev 所有函数均为纯函数（无状态修改）
 */
contract MathUtils {
    /**
     * 计算无符号整数数组的总和
     * @param numbers 无符号整数数组，长度任意
     * @return total 数组元素的总和
     * @notice 如果数组为空，返回0
     * @dev 使用循环实现，Gas消耗与数组长度线性相关
     */
    function sum(uint[] memory numbers) public pure returns (uint total) {
        total = 0;
        for (uint i = 0; i < numbers.length; i++) {
            total += numbers[i];
        }
    }
}
```

------

### **5. 为什么使用 NatSpec？**

1. **自动生成文档**：工具如 `solc` 或 `hardhat-docgen` 可以提取 NatSpec 生成 HTML/Markdown 文档。
2. **提升可读性**：明确函数用途和参数，方便其他开发者调用。
3. **钱包/IDE 支持**：MetaMask 等钱包会在用户交互时显示 `@notice` 内容。

------

### **6. 验证注释有效性**

- 使用 Solidity 编译器检查：

  ```
  solc --userdoc --devdoc your_contract.sol
  ```

- 输出会包含提取的 NatSpec 内容。

------

### **7. 注意事项**

- **单行注释**：可以用 `///`（3个斜杠）替代 `/** */`，但仅适用于单行：

  ```
  /// @notice 计算数组总和
  function sum() public pure {}
  ```

- **继承文档**：子合约可通过 `@inheritdoc` 继承父合约的注释。