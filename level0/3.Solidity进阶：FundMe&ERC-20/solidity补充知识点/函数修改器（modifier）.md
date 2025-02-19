### 函数修改器（modifier）

- 可以用来改变一个函数的行为，比如用于在函数执行前检查某种前置条件。
- 函数修改器使用关键字 `modifier` , 以下代码定义了一个 `onlyOwner` 函数修改器， 然后使用修改器 `onlyOwner` 修饰 `transferOwner()` 函数：

```
contract owned {
    function owned() public { owner = msg.sender; }
    address owner;

    modifier onlyOwner {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }


   function transferOwner(address _newO) public onlyOwner {
        owner = _newO;
    }
}
```

- 函数修改器一般是带有一个特殊符号 `_;` ；当你的合约中的函数使用了函数修改器，你需要先执行函数修改器中的代码，当_;在下面。
- 可以接收参数，使用它的函数也需要接受同一个参数
- 可以多个修改器一起使用
- 可以被继承，可以被继承合约重写