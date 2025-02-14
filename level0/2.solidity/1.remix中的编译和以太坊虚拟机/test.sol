

// comment : this is my first smart contract (这是我第一个智能合约)



/** 
    uint256 a = 1 + 1 ;
    uint256 a = 1.add(1);
    uint256 a = add(1,1);
    这是高级编程语言(给人看的) 
    这3种表达形式可不可以被编译，决定权在于compiler 
    有可能compiler 1.0只认识 第一种写法，到2.0就认识了第二种写法，这是compiler的限制(特性)，只能向前兼容(高版本)
    把这行代码转换为计算机能识别的代码，这个过程就叫编译，执行编译的就是编译器
    compiler -> compile(uint256 a = 1 + 1 ;) -> 010001001 bytecode（字节码）

    EVM(Ethreum virtual machine) 以太坊虚拟机 -> execute(010001001 bytecode) -> result
    eg:
        EVM pairs 只允许add 不允许divide
        - uint256 a = 1 + 1 ; -> bytecode
        - uint256 a = 1 / 1 ; 执行不了
    随着EVM的增加，我们的指令集(opcode)在增加,能承载的操作更多
**/


