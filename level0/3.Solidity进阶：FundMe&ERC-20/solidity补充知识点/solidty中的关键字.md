### `contract` 关键字

- Solidity 中使用 `contract` 关键字定义合约，类似于其他编程语言中的类。

### this 关键字

- 在合约内部可以使用 `this` 关键字表示当前合约，并可以将其显式转换为 `address` 类型。

```
contract Hello {
    function getAddress() public view returns (address) {
        return address(this);  // 返回当前合约的地址
    }
}
```

### 构造函数（Constructor）

- 构造函数使用 `constructor` 关键字声明，在合约部署时执行。用于初始化合约状态。
- 在合约部署时进行一次调用，并且以后再也不会调用，用于初始化合约状态。

### Constant 和 Immutable 状态变量

- 状态变量声明为 `constant` 或者 `immutable` ，在这两种情况下，合约一旦部署之后，变量将不在修改。

- 对于 `constant` 变量, 他的值在编译器确定，而对于 `immutable`, 它的值**在部署时确定**。
- 如果状态变量声明为 `constant` (常量)。在这种情况下，只能使用那些在编译时有确定值的表达式来给它们赋值。一般大写。
- 可以在合约的构造函数中或声明时为不可变的变量分配任意值。 不可变量在构造期间无法读取其值，并且只能赋值一次。
- 不可变量(Immutable) 是 Solidity 0.6.5 引入的，因此0.6.5 之前的版本不可用。

```
pragma solidity >=0.6.0;

contract ImmutableExample {
    uint immutable maxBalance;

    constructor(uint _maxBalance) public {
        maxBalance = _maxBalance;
    }
}
```

### 类型转换

类型转换就是把一种数据类型转换成其他的数据类型。在 solidity 中类型转换分为隐式转换（自动转换）和显式转换（人工转换）。

1. 隐式转换

   - 隐式转换时必须符合一定条件，不能导致信息丢失。
   - 例如，uint8 可以转换为 uint16，但是 int8 不可以转换为 uint256，因为 int8 包含 uint256 中不允许的负值。
   - 一般来说，如果转换后不会造成信息丢失，系统会自动进行隐式转换。

2. 显示转换

   - 显示转换就是在隐式转换无法生效的情况下，人为进行的转换，比如说位数的截断、无法覆盖导致的溢出等等。

     ```
     int8 y = -3; 
     uint x = uint(y); 
     //如果转换成更小的类型，变量的值会丢失高位。 
     uint32 a = 0x12345678; 
     uint16 b = uint16(a); // b = 0x5678 
     //转换成更大的类型，将向左侧添加填充位 
     uint16 a = 0x1234;
     uint32 b = uint32(a); // b = 0x00001234 
     //转换到更小的字节类型，会丢失后面数据。 
     bytes2 a = 0x1234; 
     bytes1 b = bytes1(a); // b = 0x12 
     //转换为更大的字节类型时，向右添加填充位。 
     bytes2 a = 0x1234; 
     bytes4 b = bytes4(a); // b = 0x12340000 
     //把整数赋值给整型时，不能超出范围，发生截断，否则会报错。 
     uint8 a = 12; // 正确 
     uint32 b = 1234; // 正确 
     uint16 c = 0x123456; // 错误,
     ```



**selfdestruct 函数**（简单了解）

- **销毁合约**：

  - 调用 `selfdestruct` 后，合约将被永久销毁，其代码和存储将从区块链中移除。
  - 销毁后，合约地址将不再可用，任何尝试与销毁的合约交互的操作都会失败。

- **转移剩余以太币**：

  - 在销毁合约之前，合约中剩余的所有以太币将被发送到指定的目标地址。
  - 目标地址可以是外部账户（EOA）或其他合约地址。

- `selfdestruct` **的语法**

  ```
  selfdestruct(address payable recipient);
  ```

  - **`recipient`**：
    - 接收合约中剩余以太币的地址。
    - 必须是一个 `payable` 地址。

- **`selfdestruct` 的替代方案**

  由于 `selfdestruct` 的不可逆性和潜在风险，某些场景下可以使用替代方案：

  1. **暂停合约**：
     - 实现一个暂停机制，允许合约所有者暂停合约的功能，而不是销毁合约。
  2. **资金提取**：
     - 实现一个提取函数，允许合约所有者提取合约中的资金，而不销毁合约。



**type(C) 用法**:

- **说明**: Solidity 0.6 版本开始，可以通过 `type(C)` 获取合约的类型信息。
  - `type(Hello).name`: 获取合约的名字。
  - `type(Hello).creationCode`: 获取创建合约的字节码。
  - `type(Hello).runtimeCode`: 获取合约运行时的字节码。3
  
  

**事件（Events）**

- **事件用于与外部应用交互**，通过事件通知外部发生的合约状态变化。
- **使用emit关键字**触发事件。
- 示例代码：

```
pragma solidity >=0.5.0;
contract EventExample {
    event DataChanged(uint newValue);
    uint public data;
    function setData(uint _data) public {
        data = _data;
        emit DataChanged(_data);  // 触发事件
    }
}
```



#### **ABI 编码及解码函数 API**

ABI（应用二进制接口）函数用于编码和解码 Solidity 中的数据类型，特别适用于合约间交互时处理复杂数据结构。多用于传输复杂数据，节流.

##### **1. 编码函数**

- **abi.encode(...) returns (bytes)**：对输入的参数进行 ABI 编码，返回字节数组。

```
bytes memory encodedData = abi.encode(uint(1), address(0x123));
```

- **abi.encodePacked(...) returns (bytes)**：将多个参数进行紧密打包编码，不填充到 32 字节。适用于哈希计算。

```
bytes memory packedData = abi.encodePacked(uint(1), address(0x123));
```

- **abi.encodeWithSelector(bytes4 selector, ...) returns (bytes)**：将参数编码，并在前面加上函数选择器（用于外部调用）。

```
bytes4 selector = bytes4(keccak256("transfer(address,uint256)")); 

bytes memory encodedWithSelector = abi.encodeWithSelector(selector, address(0x123), 100);
```

- **abi.encodeWithSignature(string signature, ...) returns (bytes)**：通过函数签名生成函数选择器，并将参数编码。

```
bytes memory encodedWithSignature = abi.encodeWithSignature("transfer(address,uint256)", address(0x123), 100);
```

**2. 解码函数**

- **abi.decode(bytes memory encodedData, (...)) returns (...)**：对编码的数据进行解码，返回解码后的参数。

```
(uint a, address b) = abi.decode(encodedData, (uint, address));
```



#### **数学和密码学函数 API**

Solidity 提供了一些常用的数学与密码学函数，用于处理复杂运算和数据加密。

##### **1. 数学函数**

- **addmod(uint x, uint y, uint k) returns (uint)**：计算 `(x + y) % k`，在任意精度下执行加法再取模，支持大数运算。

```
uint result = addmod(10, 20, 7); // 结果为 2
```

- **mulmod(uint x, uint y, uint k) returns (uint)**：计算 `(x * y) % k`，先进行乘法再取模。

```
uint result = mulmod(10, 20, 7); // 结果为 6
```

**2. 密码学哈希函数**

- **keccak256(bytes memory) returns (bytes32)**：使用 Keccak-256 算法计算哈希值（以太坊的主要哈希算法）。

```
bytes32 hash = keccak256(abi.encodePacked("Hello, World!"));
```

- **sha256(bytes memory) returns (bytes32)**：计算 SHA-256 哈希值。

```
bytes32 hash = sha256(abi.encodePacked("Hello, World!"));
```

- **ripemd160(bytes memory) returns (bytes20)**：计算 RIPEMD-160 哈希值，生成较短的 20 字节哈希值。

```
bytes20 hash = ripemd160(abi.encodePacked("Hello, World!"));
```

##### **3. 椭圆曲线签名恢复**

- **ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) returns (address)**：通过椭圆曲线签名恢复公钥对应的地址，常用于验证签名。

```
address signer = ecrecover(hash, v, r, s);
```



#### ABI

**ABI（Application Binary Interface）** 是以太坊智能合约与外部世界（如前端应用、其他合约）交互的桥梁。它定义了如何编码和解码合约方法的调用数据，以及如何解析合约返回的数据。

- ABI 通常在编译合约时自动生成，并保存在 `artifacts/` 目录下。
