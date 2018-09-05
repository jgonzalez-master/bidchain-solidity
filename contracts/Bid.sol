pragma solidity ^0.4.24;

import "./SafeMath.sol";

contract Bid {
    using SafeMath for uint256;
    
    uint id;
    address beneficiary;
    uint deadline;
    string name;
    mapping (address => uint) private bidders;
    address[] totalBiddersArr;
    address maxBidder;
    uint maxBid;
    bidState state;
    string description;

    event AddBid(address _bidder, uint _amount);

    enum bidState { Bidding, Payed }

    modifier deadlineReached { 
        require(now > deadline, "Bid hasn't reached the deadline.");
        _;
    }

    modifier hasBalance { 
        require(address(this).balance > 0, "Bid doesn't have any balance.");
        _;
    }

    constructor(string _name, uint _deadline, address _beneficiary, string _description) public {
        name = _name;
        deadline = now + _deadline;
        beneficiary = _beneficiary;
        state = bidState.Bidding;
        description = _description;
    }

    function currentWinner() public view returns (address, uint){
        return (maxBidder, maxBid);
    }

    function totalBidders() public view returns (uint) {
        return totalBiddersArr.length;
    }

    function addBid() public payable {
        require(msg.value > maxBid, "Bid needs to be higher than the current.");
        require(msg.sender != beneficiary, "Beneficiary cannot be a bidder.");

        maxBid = msg.value;
        maxBidder = msg.sender;

        if(bidders[maxBidder] == 0) totalBiddersArr.push(maxBidder);
        bidders[maxBidder] = bidders[maxBidder].add(maxBid);
        emit AddBid(maxBidder, maxBid);
    }

    function payout() public deadlineReached hasBalance {
        
        beneficiary.transfer(maxBid);
        state = bidState.Payed;
    }

    function refund(address _bidderAddr) public deadlineReached hasBalance {
        require(_bidderAddr != maxBidder, "Maximum bidder cannot be refunded.");

        uint amountToSend = bidders[_bidderAddr];
        bidders[_bidderAddr] = 0;
        _bidderAddr.transfer(amountToSend);
    }

    function disable() public deadlineReached {
        require(state == bidState.Payed, "Bid needs to be payed to the owner before destruct.");
        selfdestruct(beneficiary);
    }
}