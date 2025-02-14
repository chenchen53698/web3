// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract HelloWorld{
    string strVar = 'Hello World';
    //声明一个名字为Info的结构体
    struct Info {
        string phrase;
        uint256 id;
        address addr;
    }
    //声名一个名字为infos的Info数组
    Info[] infos;
    //声名一个映射
    mapping(uint256 id=> Info info) infoMapping;
    //读取
    function sayHello(uint256 _id) public view returns(string memory){
        //address(0x0) 空地址
        if(infoMapping[_id].addr == address(0x0)){
            return addinfo(strVar);
        }else{
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
    function setHelloWorld(string memory newString,uint256 _id) public {
        //msg是solidity中的环境变量 msg.sender获取是谁发起这笔合约
        Info memory info = Info(newString,_id,msg.sender);
        infoMapping[_id] = info;
        // infos.push(info);
    }
    //计算
    function addinfo(string memory helloWorldStr) internal pure returns(string memory){
        return string.concat(helloWorldStr," FORM Ceepe's contract.");
    }
}

/*
    struct(声名一个结构体):结构体 一般用于存储多个不同数据类型，把它存在同一个变量里
    array:数组  可以把多个相同类型的(基础)数据类型存储在一起
    mapping:映射 也是用来存储多个元素，它是存储kv键值对
*/
