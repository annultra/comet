import hre, { ethers } from 'hardhat';
import { exp, expect } from './helpers';
import { HttpNetworkConfig } from 'hardhat/types/config';
import {
  SimplePriceFeed__factory,
  SimpleWstETH__factory,
  WstETHPriceFeed__factory
} from '../build/types';

export async function makeWstETH({ stEthPrice, tokensPerStEth }) {
  const SimplePriceFeedFactory = (await ethers.getContractFactory('SimplePriceFeed')) as SimplePriceFeed__factory;
  const stETHpriceFeed = await SimplePriceFeedFactory.deploy(stEthPrice, 8);

  const SimpleWstETHFactory = (await ethers.getContractFactory('SimpleWstETH')) as SimpleWstETH__factory;
  const simpleWstETH = await SimpleWstETHFactory.deploy(tokensPerStEth);

  const wstETHPriceFeedFactory = (await ethers.getContractFactory('WstETHPriceFeed')) as WstETHPriceFeed__factory;
  const wstETHPriceFeed = await wstETHPriceFeedFactory.deploy(
    stETHpriceFeed.address,
    simpleWstETH.address
  );
  await wstETHPriceFeed.deployed();

  return {
    simpleWstETH,
    stETHpriceFeed,
    wstETHPriceFeed
  };
}

const testCases = [
  {
    stEthPrice: 128874639019,
    tokensPerStEth: exp(9, 18),
    result: 0
  }
];

describe.only('wstETH price feed', function () {
  for (const { stEthPrice, tokensPerStEth, result } of testCases) {
    it(`stEthPrice ${stEthPrice} tokensPerStEth ${tokensPerStEth} -> ${result}`, async () => {
      const { wstETHPriceFeed } = await makeWstETH({ stEthPrice, tokensPerStEth });
      const latestRoundData = await wstETHPriceFeed.latestRoundData();
      const price = latestRoundData.answer.toBigInt();

      expect(price).to.eq(result);
    });
  }
});
