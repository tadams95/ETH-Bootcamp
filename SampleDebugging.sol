//SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

contract MyContract {
    uint256 public myUint = 123;

    function setMyUint(uint256 newUint) public {
        myUint = newUint;
    }
}
