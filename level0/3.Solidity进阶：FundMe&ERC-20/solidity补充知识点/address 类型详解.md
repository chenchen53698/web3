#### `address` 的属性和方法

- **balance**

  - 使用 `balance` 属性获取地址的以太坊余额（单位为 wei）。

- payable

  - **类型转换**
  - 默认地址是不可以进行ETH交易的，所以要进行类型转换

- **transfer()**

  - `transfer` 会发送指定数量的 ETH 到目标地址。
  - 如果发送失败，`transfer` 会抛出异常并回滚整个交易。
  - `transfer` 的 gas 限制是 2300 gas，这意味着目标地址的 `fallback` 函数只能执行非常有限的操作。
  - `transfer` 的 gas 限制较低，因此不适合用于需要复杂逻辑的合约。
  - 如果目标地址是一个合约，且其 `fallback` 函数需要更多的 gas 来执行操作，`transfer` 可能会导致交易失败。
  - 写法: payable(address).transfer(value)

  ```
  payable(msg.sender).transfer(address(this).balance);
  ```

  

- **send()**

  - `send` 与 `transfer` 类似，但它不会抛出异常，而是返回一个布尔值来表示发送是否成功。
  - `send` 的 gas 限制也是 2300 gas，与 `transfer` 相同。
  - 由于 `send` 不会抛出异常，开发者需要手动检查返回值并处理发送失败的情况。
  - 写法:bool 名字 = payable(address).send(value)

  ```
  bool success = payable(msg.sender).send(address(this).balance);
  require(success, "tx failed");
  ```

  

- **call()**

  - `call` 不仅可以发送 ETH，还可以调用目标地址的函数。
  - `call` 没有 gas 限制，这意味着目标地址的 `fallback` 函数可以执行更复杂的操作。
  - `call` 返回两个值：一个布尔值表示调用是否成功，以及一个字节数组（通常用于函数调用的返回值）。
  - `call` 没有 gas 限制，因此需要特别注意目标合约的 `fallback` 函数是否会消耗过多的 gas。
  - 由于 `call` 的灵活性，它也可能带来更多的安全风险，例如重入攻击。因此，在使用 `call` 时，建议遵循“检查-效果-交互”模式，并使用重入锁来防止重入攻击。
  - 写法:(bool , 函数返回值result)=address.call{value:value}("函数名")

  ```
  //没有返回值没有回调函数
  bool success;
  (success, ) = payable(msg.sender).call{value: address(this).balance}("");
  require(success, "transfer tx failed");
  ```

  

