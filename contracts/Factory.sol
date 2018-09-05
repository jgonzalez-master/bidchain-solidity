pragma solidity ^0.4.24;

import "./Bid.sol";

contract Factory{

    uint public currentId;

    event NewBid(address _bidAddress);

    mapping(uint => address) private bidInfo;

    function newCampaign(string _name, uint _duration, address _beneficiary, string _description) public returns (uint) {
        Bid c = new Bid(_name, now + _duration, _beneficiary, _description);
        bidInfo[currentId] = c;
        emit NewBid(c);
        currentId++;
        return currentId-1;
    }

    function getBidInfo(uint _id) public view returns (address) {
        return bidInfo[_id];
    }
}
