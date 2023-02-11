const truffleAssertions = require("truffle-assertions");

const SpaceBear = artifacts.require("SpaceBear");

//unit testing our deployed NFT contract
contract("SpaceBear", (accounts) => {
  it("should credit an NFT to a specific account", async () => {
    const spacebearInstance = await SpaceBear.deployed();
    let txResult = await spacebearInstance.safeMint(
      accounts[1],
      "spacebear_1.json"
    );
    //assert.equal(txResult.logs[0].event, "Transfer", "Event is not the transfer event");
    console.log(txResult.logs[0].args);
    truffleAssertions.eventEmitted(txResult, "Transfer", {
      from: "0x0000000000000000000000000000000000000000",
      to: accounts[1],
      tokenId: web3.utils.toBN("0"),
    });
    assert.equal(
      await spacebearInstance.ownerOf(0),
      accounts[1],
      "The Owner of Token 1 is not equal to account 2"
    );
  });
});
