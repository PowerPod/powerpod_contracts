const { ethers, upgrades } = require('hardhat')

async function main() {
  const NFTSale = await ethers.getContractFactory('RWANFTSale')

  // address _nftAddress,
  // address _usdcAddress,
  // uint256 _whitelistStart,
  // uint256 _publicStart,
  // uint256 _publicEnd,
  // uint256 _maxSupply
  const nftSale = await upgrades.deployProxy(NFTSale, [
    '0xeB0e05D4b4e4dF7c36a15EbB009fC18CA0f2944b',
    '0x036CbD53842c5426634e7929541eC2318f3dCF7e',
    1715734800,
    1715756400,
    1715763600,
    1000,
  ])

  await nftSale.waitForDeployment()
  console.log('nftSale deployed to:', await nftSale.getAddress())
}

main()
