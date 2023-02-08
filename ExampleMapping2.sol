// SPDX-License-Identifier: MIT

pragma solidity 0.8.17;

contract ExampleMappingWithdrawals {
    mapping(address => uint256) public balanceReceived;

    function sendMoney() public payable {
        balanceReceived[msg.sender] += msg.value;
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function withdrawAllMoney(address payable _to) public {
        uint256 balanceToSendOut = balanceReceived[msg.sender];
        balanceReceived[msg.sender] = 0;
        _to.transfer(balanceToSendOut);
    }
}
