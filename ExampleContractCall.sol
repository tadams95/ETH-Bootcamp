//SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

contract ContractOne {
    mapping(address => uint256) public addressBalances;

    function deposit() public payable {
        addressBalances[msg.sender] += msg.value;
    }
}

contract ContractTwo {
    receive() external payable {}

    function depositOnContractOne(address _contractone) public {
        // bytes memory payload = abi.encodeWithSignature("deposit()");
        (bool success, ) = _contractone.call{value: 10, gas: 100000}("");
        require(success);
    }
}
