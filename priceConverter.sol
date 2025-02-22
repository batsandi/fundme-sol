// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

library priceConverter {


    // function withdraw() public{}

    function getPrice() internal view returns (uint256){
        // address 0x6D41d1dc818112880b40e26BD6FD347E41008eDA
        // ABI

        AggregatorV3Interface priceFeed = AggregatorV3Interface(
            0x6D41d1dc818112880b40e26BD6FD347E41008eDA
        );
        (,int256 answer,,,) = priceFeed.latestRoundData();
        return uint256(answer * 1e10);
    }

    function getConversionRate(uint256 ethAmount) internal view returns(uint256) {
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18 ;
        return ethAmountInUsd;
    }


}