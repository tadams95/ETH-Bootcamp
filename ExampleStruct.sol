// SPDX-License-Identifier: MIT

pragma solidity 0.8.17;

contract Wallet {
    PaymentReceived public payment;

    function payContract() public payable {
        payment = new PaymentReceived(msg.sender, msg.value);
    }
}

contract PaymentReceived {
    address public from;
    uint256 public amount;

    constructor(address _from, uint256 _amount) {
        from = _from;
        amount = _amount;
    }
}

contract Wallet2 {
    //save on gas costs using a Struct

    struct PaymentReceivedStruct {
        address from;
        uint256 amount;
    }
    PaymentReceivedStruct public payment;

    function payContract() public payable {
        // payment = PaymentReceivedStruct(msg.sender, msg.value);
        payment.amount = msg.value;
        payment.amount = msg.value;
    }
}
