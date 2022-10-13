import hre, { ethers } from 'hardhat';
import { expect } from './helpers';
import { HttpNetworkConfig } from 'hardhat/types/config';
import {
  WSTETHPriceFeed,
  WSTETHPriceFeed__factory
} from '../build/types';

export async function forkMainnet() {
  const mainnetConfig = hre.config.networks.mainnet as HttpNetworkConfig;
  await ethers.provider.send(
    'hardhat_reset',
    [
      {
        forking: {
          jsonRpcUrl: mainnetConfig.url,
        },
      },
    ],
  );
}

export async function resetHardhatNetwork() {
  // reset to blank hardhat network
  await ethers.provider.send('hardhat_reset', []);
}


export async function makeWstETH() {
  const wstETHPriceFeedFactory = (await ethers.getContractFactory('WSTETHPriceFeed')) as WSTETHPriceFeed__factory;
  const wstETHPriceFeed = await wstETHPriceFeedFactory.deploy();
  await wstETHPriceFeed.deployed();

  return {
    wstETHPriceFeed
  };
}

describe.only('wstETH price feed', function () {
  before(forkMainnet);
  after(resetHardhatNetwork);

  it('tests something', async () => {
    const { wstETHPriceFeed } = await makeWstETH();
    const latestRoundData = await wstETHPriceFeed.latestRoundData();

    console.log(latestRoundData.answer.toBigInt());

    expect(true).to.be.true;
  });

});
