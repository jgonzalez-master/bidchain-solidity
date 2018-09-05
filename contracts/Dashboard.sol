pragma solidity ^0.4.24;

import "./Factory.sol";

contract Dashboard {

    Factory public database;
    uint public bidCount;

    constructor(address _factorAddr) public {
        database = Factory(_factorAddr);
    }

    modifier validateAddress(uint _id) {
        require(getBidAddress(_id) != address(0), "Invalid address.");
        _;
    }

    function getBidAddress(uint _id) public view returns (address) {
        return database.getBidInfo(_id);
    }

    function newBid(string _name, uint _duration, address _beneficiary, string _description, string _url)  public {
        database.newBid(_name, _duration, _beneficiary, _description, _url);
        bidCount++;
    }

    function viewCurrentBid(uint _id) public validateAddress(_id) view returns (string, uint, address, string, string, uint, uint) {
        Bid c = Bid(getBidAddress(_id));
        return c.bidDetails();
    }

    function makeBid(uint _id)  public payable validateAddress(_id) {
        require(msg.value > 0, "New bid needs to be greater than zero.");
        Bid c = Bid(getBidAddress(_id));
        c.addBid.value(msg.value);
    }

    function getRefund(uint _id) public validateAddress(_id) {
        Bid c = Bid(getBidAddress(_id));
        c.refund(msg.sender);
    }

    function pushPayout(uint _id) public validateAddress(_id) {
        Bid c = Bid(getBidAddress(_id));
        c.payout();
    }
}
