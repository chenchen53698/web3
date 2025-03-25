在 Solidity 中，`fallback` 函数和 `receive` 函数是两种特殊的函数，用于处理以太币（ETH）的接收和未匹配的函数调用。以下是它们的详细说明和区别：

------

### 1. **`receive` 函数**

- **用途**：专门用于接收纯 ETH 转账（无数据的交易）。

- **触发条件**：

  - 调用时附带 ETH（`msg.value > 0`）。
  - 交易中无 `calldata`（即 `msg.data` 为空）。

- **声明方式**：

  ```
  receive() external payable {
      // 逻辑代码
  }
  ```

- **注意**：

  - 必须标记为 `external payable`。
  - 一个合约最多有一个 `receive` 函数。

------

### 2. **`fallback` 函数**

- **用途**：

  - 处理以下两种情况：
    1. 调用合约时附带 ETH，但无 `receive` 函数或 `msg.data` 非空。
    2. 调用合约中不存在的函数。

- **触发条件**：

  - 调用不匹配任何函数签名。
  - 或 ETH 转账无法被 `receive` 处理。

- **声明方式**：

  ```
  // 新版 Solidity（0.6.0+）
  fallback() external payable {
      // 逻辑代码
  }
  ```

- **注意**：

  - 可以标记为 `payable`（表示能接收 ETH）。
  - 如果没有 `payable`，合约无法通过 `fallback` 接收 ETH（会抛出异常）。

------

### 3. **执行优先级**

当合约收到 ETH 时，逻辑如下：

1. 如果 `msg.data` 为空且存在 `receive()`：
   - 调用 `receive()`。
2. 如果 `msg.data` 非空或不存在 `receive()`：
   - 调用 `fallback()`。
3. 如果两者均未实现或未标记为 `payable`：
   - 交易失败（除非合约是 payable 的构造函数）。

------

### 4. **经典 `fallback`（旧版 Solidity）**

在 Solidity <0.6.0 中，`fallback` 是一个无名函数：

```
function() external payable {
    // 逻辑代码
}
```

新版拆分为 `receive` 和 `fallback` 以提高明确性。

------

### 5. **使用场景示例**

```
contract Example {
    event Received(address sender, uint amount);
    event FallbackCalled(address sender, uint amount, bytes data);

    // 接收纯 ETH 转账
    receive() external payable {
        emit Received(msg.sender, msg.value);
    }

    // 处理无效调用或复杂 ETH 转账
    fallback() external payable {
        emit FallbackCalled(msg.sender, msg.value, msg.data);
    }
}
```

------

### 6. **关键区别**

| 特性               | `receive`             | `fallback`                  |
| :----------------- | :-------------------- | :-------------------------- |
| 触发条件           | 纯 ETH 转账（无数据） | 无效调用或带数据的 ETH 转账 |
| 是否必须 `payable` | 是                    | 可选                        |
| 替代旧版           | 无                    | 替代旧的无名 `function()`   |

------

### 7. **安全注意事项**

- 如果合约需要接收 ETH，至少实现 `receive() external payable`。
- 在 `fallback` 中避免复杂逻辑（可能被恶意调用）。

通过合理使用这两个函数，可以灵活处理 ETH 转账和未知调用。