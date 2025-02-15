// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract HelloWorld {
    string strVar = "Hello World";
    //声明一个名字为Info的结构体
    struct Info {
        string phrase;
        uint256 id;
        address addr;
    }
    //声名一个名字为infos的Info数组
    Info[] infos;
    //声名一个映射
    mapping(uint256 id => Info info) infoMapping;

    //读取
    function sayHello(uint256 _id) public view returns (string memory) {
        //address(0x0) 空地址
        if (infoMapping[_id].addr == address(0x0)) {
            return addinfo(strVar);
        } else {
            return addinfo(infoMapping[_id].phrase);
        }
        // for(uint256 i = 0; i< infos.length;i++){
        //     if(infos[i].id == _id){
        //         return addinfo(infos[i].phrase);
        //     }
        // }
        // return addinfo(strVar);
    }

    //修改
    function setHelloWorld(string memory newString, uint256 _id) public {
        //msg是solidity中的环境变量 msg.sender获取是谁发起这笔合约
        // Info memory info;//赋值方式1
        Info memory info = Info(newString, _id, msg.sender); //赋值方式2
        // Info memory info = Info({account: address(0x0), gender: false, age: 18});//赋值方式3
        infoMapping[_id] = info;
        // infos.push(info);
    }

    //计算
    function addinfo(
        string memory helloWorldStr
    ) internal pure returns (string memory) {
        return string.concat(helloWorldStr, " FORM Ceepe's contract.");
    }
}

// 在函数内 //赋值方式4
// function updatePersion() public {
//     person.account = msg.sender;
//     person.gender = true;
//     person.age = 12;
// }

/*
    struct(声名一个结构体):结构体 一般用于存储多个不同数据类型，把它存在同一个变量里
        结构体的限制
            不能包含自身类型作为成员：结构体不能直接包含其自身类型作为成员，但可以通过映射来间接包含。
        赋值方式:
            1.仅声明变量而不赋值，此时会使用默认值创建结构体变量 
            2.按成员顺序（结构体声明时的顺序）赋值
            3.具名方式赋值
            4.以更新成员变量的方式给结构体变量赋值

    array:数组  可以把多个相同类型的(基础)数据类型存储在一起
        在 Solidity 中，数组类型可以通过在数据类型后添加 [] 来定义。
        Solidity 支持两种数组类型:
            静态数组（Fixed-size Arrays）:
                长度固定，数组的大小在定义时确定，之后无法改变。
            动态数组（Dynamic Arrays）:
                长度可变，可以根据需要动态调整。
                动态数组可以使用 new 关键字在内存中创建，大小基于运行时确定。
            特殊数组类型： 
                bytes:是一个动态分配大小的字节数组，类似于 byte[]，但 gas 费用更低。使用长度受限的字节数组时，建议使用 bytes1 到 bytes32 类型，以减少 gas 费用。
                string:用于存储任意长度的字符串（UTF-8编码），对字符串进行操作时用到。

    mapping:映射 也是用来存储多个元素，是一种键值对存储结构，用于根据键快速访问值。
        键类型的限制:键类型不能是映射、变长数组、合约、枚举或结构体。
        值类型的无限制：值类型可以是任何类型，包括映射类型。
        删除操作的特殊性:从映射中删除一个键的值，需使用delete关键字，但键本身不会被移除，只是值被重置为默认值。    
*/
