### **`uint storedData;`**

- **可见性**：
  - 如果没有显式指定可见性修饰符（如 `public`、`private` 等），状态变量的默认可见性是 **`internal`**。
  - `internal` 表示该状态变量只能在当前合约及其继承合约中访问，外部合约或用户无法直接访问。
- **Getter 函数**：
  - 不会自动生成 Getter 函数。
  - 如果需要从外部访问 `storedData`，必须手动编写一个 `public` 或 `external` 函数来返回其值。

### **`uint public storedData;`**

- **可见性**：
  - `public` 表示该状态变量是公开的，可以在当前合约、继承合约以及外部合约或用户中访问。
- **Getter 函数**：
  - Solidity 会自动为 `public` 状态变量生成一个 Getter 函数。
  - Getter 函数的名称与状态变量相同，例如 `storedData()`。

### 对比总结

| 特性            | `uint storedData;`                   | `uint public storedData;`          |
| :-------------- | :----------------------------------- | :--------------------------------- |
| **可见性**      | `internal`（默认）                   | `public`                           |
| **外部访问**    | 不可直接访问，需手动实现 Getter 函数 | 可以直接访问，自动生成 Getter 函数 |
| **Getter 函数** | 无自动生成，需手动实现               | 自动生成，函数名为 `storedData()`  |
| **使用场景**    | 需要隐藏数据，仅内部使用             | 需要公开数据，供外部访问           |

### 代码示例对比

#### 1. `uint storedData;`（默认 `internal`）

```
contract MyContract {
    uint storedData; // 默认是 internal

    function setData(uint _data) public {
        storedData = _data;
    }

    function getData() public view returns (uint) {
        return storedData; // 手动实现 Getter 函数
    }
}
```

- 外部调用者无法直接访问 `storedData`，必须通过 `getData()` 函数。

#### 2. `uint public storedData;`

```
contract MyContract {
    uint public storedData; // public 状态变量

    function setData(uint _data) public {
        storedData = _data;
    }
}
```

- 外部调用者可以直接通过 `storedData()` 函数访问 `storedData` 的值。

------

### 选择使用哪种方式

- 如果需要将状态变量暴露给外部合约或用户，使用 `public`。
- 如果状态变量仅用于内部逻辑，不希望外部访问，使用默认的 `internal` 或显式声明为 `private`。

### 注意事项

1. **Gas 消耗**：

   - 自动生成的 Getter 函数是 `view` 函数，调用时不会消耗 Gas（在外部调用时）。
   - 手动实现的 Getter 函数也应该是 `view` 或 `pure` 函数。

2. **数据隐私**：

   - 即使状态变量是 `public`，区块链上的数据仍然是公开的，任何人都可以通过区块链浏览器查看。
   - `internal` 和 `private` 仅限制合约层面的访问权限，并不能隐藏数据。

3. **映射和数组**：

   - 对于 `public` 映射和数组，Getter 函数会接受参数。

   - 例如：

     ```
     mapping(address => uint) public balances;
     ```

     会自动生成：

     ```
     function balances(address owner) external view returns (uint);
     ```

