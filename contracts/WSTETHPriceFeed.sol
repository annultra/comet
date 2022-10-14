// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.15;

import "./vendor/@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

interface IWstETH {
    function decimals() external view returns (uint8);
    function tokensPerStEth() external view returns (uint256);
}

contract WstETHPriceFeed is AggregatorV3Interface {
    /** Custom errors **/
    error InvalidInt256();
    error NotImplemented();

    /// @notice
    uint8 public override decimals = 8;

    /// @notice
    string public constant override description = "Custom price feed for wstETH / USD";

    /// @notice
    uint public constant override version = 1;

    /// @notice
    address public immutable stETHtoUSDPriceFeed;

    /// @notice
    address public immutable wstETH;

    constructor(address stETHtoUSDPriceFeed_, address wstETH_) {
        stETHtoUSDPriceFeed = stETHtoUSDPriceFeed_;
        wstETH = wstETH_;
    }

    /**
     * @notice
     * @param
     **/
    function signed256(uint256 n) internal pure returns (int256) {
        if (n > uint256(type(int256).max)) revert InvalidInt256();
        return int256(n);
    }

    /**
     * @notice
     * @param
     **/
    function getRoundData(uint80 _roundId) override external view returns (
        uint80 roundId,
        int256 answer,
        uint256 startedAt,
        uint256 updatedAt,
        uint80 answeredInRound
    ) {
        revert NotImplemented();
    }

    /**
     * @notice
     * @param
     * @return roundId Always 0
     * @return answer XXX
     * @return startedAt Always 0
     * @return updatedAt Always 0
     * @return answeredInRound Always 0
     **/
    function latestRoundData() override external view returns (
        uint80 roundId,
        int256 answer,
        uint256 startedAt,
        uint256 updatedAt,
        uint80 answeredInRound
    ) {
        (,int256 stETHPrice, , , ) = AggregatorV3Interface(stETHtoUSDPriceFeed).latestRoundData();
        uint8 wstDecimals = IWstETH(wstETH).decimals();
        uint256 tokensPerStEth = IWstETH(wstETH).tokensPerStEth();
        int price = stETHPrice * signed256(tokensPerStEth) / signed256(10 ** wstDecimals);
        return (0, price, 0, 0, 0);
    }
}