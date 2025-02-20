### **Solidity 中的继承**

- Solidity 支持继承，使用关键字 `is` 来表示继承关系，类似于 Java 中的 `extends`。
- 当一个合约继承另一个合约时，子合约可以访问父合约的所有非私有成员。（private）
- 子合约不能再次声明已经在父合约中存在的状态变量。
- 子合约可以通过重写函数改变父合约的行为。



### **多重继承**

- Solidity 支持从多个父合约继承。使用 `is` 关键字后面可以接多个父合约。

```
contract Named is Owned, Mortal {
    // Named 合约继承了 Owned 和 Mortal
}
```

- 如果多个父合约有继承关系，合约的继承顺序需要从父合约到子合约书写。

```
contract X {}
contract A is X {}
contract C is A, X {}  // 编译出错，X 出现在继承关系中两次
```



### **父合约构造函数**

- 子合约继承父合约时，父合约的构造函数会被编译器拷贝到子合约的构造函数中执行。
- 父合约构造函数无参数的情况

```
contract A {
    uint public a;

    constructor() {
        a = 1;
    }
}

contract B is A {
    uint public b;

    constructor() {
        b = 2;
    }
}
```

- 父合约构造函数有参数的情况

  - **在继承列表中指定参数**

  ```
  abstract contract A {
      uint public a;
  
      constructor(uint _a) {
          a = _a;
      }
  }
  
  contract B is A(1) {
      uint public b;
  
      constructor() {
          b = 2;
      }
  }
  ```

  - **在子合约构造函数中通过修饰符调用父合约**

  ```
  contract B is A {
      uint public b;
  
      constructor() A(1) {
          b = 2;
      }
  }
  ```



### **抽象合约**

- 如果一个合约中有未实现的函数，该合约必须标记为 `abstract`，这种合约不能部署。
- 抽象合约通常用作父合约。
- **纯虚函数**
- 纯虚函数没有实现，用 `virtual` 关键字修饰，并且声明以分号 `;` 结尾。

```
abstract contract A {
    function get() virtual public;//未实现的纯虚函数
    function get2() public virtual{
    	//操作  实现的纯虚函数，可在子合约中直接使用
    } 
}
contract B is A{
	function get() public override {
        //操作
    }
    //get2不写可以直接部署后调用
}
```

- 父合约中的虚函数（使用 `virtual` 关键字修饰）可以在子合约中被重写。重写的函数必须使用 `override` 关键字。
- 当函数被重写后，父合约的函数就会被遮蔽。
- 我们可以在重写的函数中显式的用 `super`调用父合约的函数,不让父合约的函数被遮蔽。

```
contract Base {
    uint public a;
    function foo() virtual public {
        a += 2;
    }
}

contract Sub is Base {

      function foo() public override {
        super.foo(); // 或者 Base.foo();
          a += 1;
      }
}
```

