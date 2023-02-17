//SPDX-License-Identifier: MIT

pragma solidity 0.8.17;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

contract SimpleWallet is Ownable {
   
    mapping(address => uint) public allowance;

    function addAllowance(address _who, uint _amount) public onlyOwner {
        allowance[_who] = _amount;
    }

    function isOwner() internal view returns(bool) {
        return owner() == msg.sender;
    }
  

    modifier ownerOrAllowed(uint _amount) {
        require(isOwner() || allowance[msg.sender] > _amount, "You are not allowed");
        _;
    }

    function withdrawMoney(address payable _to, uint256 _amount)
        public
        ownerOrAllowed(_amount)
    {
        _to.transfer(_amount);
    }

    receive()  external payable  {

    }
}
