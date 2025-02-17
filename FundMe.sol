// Get funds from users
// Withdraw funds to contract owner
// Set a minimum donation amount

// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {priceConverter} from "./priceConverter.sol";
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

error notOwner();

contract FundMe {
    using priceConverter for uint256;

    uint256 public constant MINIMUM_USD = 5 * 1e18;

    address[] public funders;
    mapping(address funder => uint256 amountFunded) public addressToAmountFunded;

    address public immutable i_owner;

    constructor(){
        i_owner = msg.sender;
    }

    function fund() public payable {
        require (msg.value.getConversionRate() > MINIMUM_USD, "Required min 5 USD in ETH");
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
    }

    function withdraw() public onlyOwner {
        for (uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++) {
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
            funders = new address[](0);
            // withdraw transfer
            // payable(msg.sender).transfer(address(this).balance);
            
            // withdraw send
            // bool sendSuccess = payable(msg.sender).send(address(this).balance);
            // require (sendSuccess, "Your Send Failed");

            // withdraw call
            (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
            require (callSuccess, "Your Call Failed");
        }
    }

    function getVersion() public view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0xfEefF7c3fB57d18C5C6Cdd71e45D2D0b4F9377bF);
        return priceFeed.version();
    }   

    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }

    modifier onlyOwner() {
        // require (msg.sender == i_owner, "Only the owner can call this function!");
        if(msg.sender != i_owner) {revert notOwner();}
        _;
    }

}