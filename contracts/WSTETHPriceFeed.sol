// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.15;

import "./vendor/@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract WSTETHPriceFeed is AggregatorV3Interface {
    uint8 public override decimals = 8;

    string public constant override description = "Custom price feed for wsETH / USD";

    uint public constant override version = 1;

    int256 public price = 7;

    constructor(int initialPrice, uint8 decimals_) {
        // price feed address
        // wsteth address
    }

    function getRoundData(uint80 _roundId) override external view returns (
        uint80 roundId,
        int256 answer,
        uint256 startedAt,
        uint256 updatedAt,
        uint80 answeredInRound
    ) {
        // throw error?
        return (_roundId, price, 0, 0, 0);
    }

    function latestRoundData() override external view returns (
        uint80 roundId,
        int256 answer,
        uint256 startedAt,
        uint256 updatedAt,
        uint80 answeredInRound
    ) {
        return (0, price, 0, 0, 0);
    }
}