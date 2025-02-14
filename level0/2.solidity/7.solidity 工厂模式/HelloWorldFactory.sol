// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/*
    为什么要在 Solidity 中使用工厂模式？
        如果要创建同一合约的多个实例，并且正在寻找一种跟踪它们并简化管理的方法。
        节省部署成本：你可以先部署工厂，之后在使用时再来部署其他合约。
        提高合约安全性
    合约也可以作为一种数据类型！！！
    引入方式：
        1.直接引入同一个文件系统下的合约
        2.引入GitHub下的合约
        3.通过包引入
*/
import { HelloWorld } from "./test.sol";

contract HelloWorldFactory{
    //声名了一个名字为hw的HelloWorld类型的变量
    HelloWorld hw;
    HelloWorld[] hws;
    //创建函数
    function createHelloWorld() public {
        hw = new HelloWorld();
        hws.push(hw);
    }
    //读取函数
    function getHelloWorldByIndex(uint256 _index) public view returns (HelloWorld) {
        return hws[_index];
    }
    //调用函数
    function callSayHelloFromFactory(uint256 _index, uint256 _id) public view returns (string memory) {
        return hws[_index].sayHello(_id);
    }
    function callSetHelloWorldFromFactory(uint256 _index, string memory newString, uint256 _id) public {
        hws[_index].setHelloWorld(newString, _id);
    }
}