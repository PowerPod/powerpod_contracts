const { ethers, upgrades } = require('hardhat')

async function main() {
  const TokenDistribution = await ethers.getContractFactory('TokenDistribution')
  const tokenDistribution = await upgrades.deployProxy(TokenDistribution, [
    '0x7a1cbe287fd36a3423151a897B97693886BE667b',
    '0xAD32172b6B8860d3015FAeAbF289823453201568',
  ])
  await tokenDistribution.waitForDeployment()
  console.log(
    'tokenDistribution deployed to:',
    await tokenDistribution.getAddress()
  )
}

main()
