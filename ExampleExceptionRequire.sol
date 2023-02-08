// SPDX-License-Identifier: MIT

pragma solidity 0.8.17;

contract ExampleExceptionRequire {
    mapping(address => uint8) public balanceReceived;

    function receiveMoney() public payable {
        //Asserts are here to check states of your Smart Contract that should never be violated
        assert(msg.value == uint8(msg.value));
        balanceReceived[msg.sender] += uint8(msg.value);
    }

    function withdrawMoney(address payable _to, uint256 _amount) public {
        //Require is for input validation and possibly returns an error message
        require(
            _amount <= balanceReceived[msg.sender],
            "Not enough funds, aborting!"
        );
        balanceReceived[msg.sender] -= uint8(_amount);
        _to.transfer(_amount);
    }
}
