//SPDX-License-Identifier: MIT

pragma solidity 0.8.17;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

contract Allowance is Ownable {
    mapping(address => uint256) public allowance;

    function addAllowance(address _who, uint256 _amount) public onlyOwner {
        allowance[_who] = _amount;
    }

    function isOwner() internal view returns (bool) {
        return owner() == msg.sender;
    }

    modifier ownerOrAllowed(uint256 _amount) {
        require(
            isOwner() || allowance[msg.sender] > _amount,
            "You are not allowed"
        );
        _;
    }

    function reduceAllowance(address _who, uint256 _amount)
        internal
        ownerOrAllowed(_amount)
    {
        allowance[_who] -= _amount;
    }
}

contract SimpleWallet is Allowance {
    function withdrawMoney(address payable _to, uint256 _amount)
        public
        ownerOrAllowed(_amount)
    {
        require(
            _amount <= address(this).balance,
            "Contract doesn't own enough money"
        );
        if (!isOwner()) {
            reduceAllowance(msg.sender, _amount);
        }
        _to.transfer(_amount);
    }

    receive() external payable {}
}
