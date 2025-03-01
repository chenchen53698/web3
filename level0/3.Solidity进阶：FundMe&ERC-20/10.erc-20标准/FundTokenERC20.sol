//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;


// FundMe
// 1. 让FundMe的参与者，在fundme合约成功后 基于 mapping 来领取(兑换)相应数量的通证
// 2. 让FundMe的参与者，transfer 通证 erc20中有
// 3. 在使用完成以后，需要burn 通证

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {FundMe} from "./FoundMe.sol";

contract FundTokenERC20 is ERC20 {
    FundMe fundMe;
    //ERC20("FundTokenERC20", "FT") 官网示例需要传入名字和简称  
    constructor(address fundMeAddr) ERC20("FundTokenERC20", "FT") {
        fundMe = FundMe(fundMeAddr);//这个传入地址是给fund合约中的函数使用的
    }
    // 1. 让FundMe的参与者，基于 mapping 来领取相应数量的通证
    function mint(uint256 amountToMint) public {
        //fundersToAmount 是一个 public 映射，那么 fundMe.fundersToAmount(msg.sender) 是合法的，因为它调用了 Solidity 自动生成的 getter 函数。
        //如果 fundersToAmount 是一个普通的映射（非 public），那么应该使用 fundMe.fundersToAmount[msg.sender] 来访问。
        //Getter 函数是 Solidity 为 public 状态变量自动生成的函数，用于读取状态变量的值。
        require(fundMe.fundersToAmount(msg.sender) >= amountToMint, "You cannot mint this many tokens");
        // require(fundMe.getFundSuccess(), "The fundme is not completed yet");
        _mint(msg.sender, amountToMint);//父合约中的方法
        fundMe.setFunderToAmount(msg.sender, fundMe.fundersToAmount(msg.sender) - amountToMint);
    }
    // 3. 在使用完成以后，需要burn 通证
    function claim(uint256 amountToClaim) public {
        // complete cliam balanceOf(erc20中获取当前人的通证)
        require(balanceOf(msg.sender) >= amountToClaim, "You dont have enough ERC20 tokens");
        require(fundMe.getFundSuccess(), "The fundme is not completed yet");
        /*to add */
        // burn amountToClaim Tokens       
        _burn(msg.sender, amountToClaim);
    }
}