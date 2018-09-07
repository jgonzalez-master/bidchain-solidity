pragma solidity ^0.4.24;

import "./Bid.sol";

contract Dashboard {

    uint public bidCount;

    mapping(uint => address) private bidInfo;


    modifier validateAddress(uint _id) {
        require(bidInfo[_id] != address(0), "Invalid address.");
        _;
    }
    
    function newBid(string _name, uint _duration, address _beneficiary, string _description, string _url) public {
        Bid bid = new Bid(_name, now + _duration, _beneficiary, _description, _url);
        bidInfo[bidCount] = bid;
        bidCount++;
    }

    function viewCurrentBid(uint _id) public validateAddress(_id) view returns (string, uint, address, string, string, uint, uint) {
        Bid bid = Bid(bidInfo[_id]);
        return bid.bidDetails();
    }

    function makeBid(uint _id)  public payable validateAddress(_id) {
        require(msg.value > 0, "New bid needs to be greater than zero.");
        Bid bid = Bid(bidInfo[_id]);
        bid.addBid.value(msg.value)(msg.sender);
    }

    function getRefund(uint _id) public validateAddress(_id) {
        Bid bid = Bid(bidInfo[_id]);
        bid.refund(msg.sender);
    }

    function pushPayout(uint _id) public validateAddress(_id) {
        Bid bid = Bid(bidInfo[_id]);
        bid.payout();
    }
}
