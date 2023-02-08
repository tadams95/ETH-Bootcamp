// SPDX-License-Identifier: MIT

pragma solidity 0.8.17;

contract ExampleExceptionRequire {
    mapping(address => uint256) public balanceReceived;

    function receiveMoney() public payable {
        balanceReceived[msg.sender] += msg.value;
    }

    function withdrawMoney(address payable _to, uint256 _amount) public {
        //Require is for input validation and possibly returns an error message
        require(
            _amount <= balanceReceived[msg.sender],
            "Not enough funds, aborting!"
        );
        balanceReceived[msg.sender] -= _amount;
        _to.transfer(_amount);
    }
}
