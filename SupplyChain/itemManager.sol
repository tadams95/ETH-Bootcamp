// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

//responsible for taking payment then transfer payment completion to ItemManager
contract Item {
    uint public priceInWei;
    uint public index;
    uint public pricePaid;

    ItemManager parentContract;

    constructor(ItemManager _parentContract, uint _priceInWei, uint _index) public {
         priceInWei = _priceInWei;
        index = _index;

        parentContract = _parentContract;
    }

    receive() external payable {
        require(pricePaid == 0, "Item is paid already");
        require(priceInWei == msg.value, "Only full payments allowed");
        pricePaid += msg.value;
        (bool success, ) = address(parentContract).call{value: msg.value}(abi.encodeWithSignature("triggerPayment(uint256)", index));
        require(success, "The transaction wasn't successful, cancelling");
    }
}

contract ItemManager {
    enum SupplyChainState {
        Created,
        Paid,
        Delivered
    }

    // a struct is a way to create a new data type
    struct S_Item {
        Item _item;
        string _identifier;
        uint256 _itemPrice;
        ItemManager.SupplyChainState _state;
    }

    mapping(uint256 => S_Item) public items;

    uint256 itemIndex;

    event SupplyChainStep(uint256 _itemIndex, uint256 _step);

    function createItem(string memory _identifier, uint256 _itemPrice) public {
        Item item = new Item(this, _itemPrice, itemIndex);
        items[itemIndex]._item = item;
        items[itemIndex]._identifier = _identifier;
        items[itemIndex]._itemPrice = _itemPrice;
        items[itemIndex]._state = SupplyChainState.Created;
        emit SupplyChainStep(itemIndex, uint256(items[itemIndex]._state));
        itemIndex++;
    }

    function triggerPayment(uint256 _itemIndex) public payable {
        require(
            items[_itemIndex]._itemPrice == msg.value,
            "Only full payments accepted"
        );
        require(
            items[_itemIndex]._state == SupplyChainState.Created,
            "Item is further in the chain"
        );

        items[_itemIndex]._state = SupplyChainState.Paid;

        emit SupplyChainStep(_itemIndex, uint256(items[_itemIndex]._state));
    }

    function triggerDelivery(uint256 _itemIndex) public {
        require(
            items[_itemIndex]._state == SupplyChainState.Created,
            "Item is further in the chain"
        );
        items[_itemIndex]._state = SupplyChainState.Delivered;

        emit SupplyChainStep(_itemIndex, uint256(items[_itemIndex]._state));
    }
}
