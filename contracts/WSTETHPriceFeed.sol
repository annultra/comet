// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.15;

import "./vendor/@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

interface IWstETH {
    function decimals() external view returns (uint8);
    function tokensPerStEth() external view returns (uint256);
}

contract WSTETHPriceFeed is AggregatorV3Interface {
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
    address public stETHtoUSDPriceFeed = 0xCfE54B5cD566aB89272946F602D76Ea879CAb4a8;

    /// @notice
    address public wstETH = 0x7f39C581F595B53c5cb19bD0b3f8dA6c935E2Ca0;

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