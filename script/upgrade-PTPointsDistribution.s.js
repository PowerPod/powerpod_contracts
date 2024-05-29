const { ethers, upgrades } = require('hardhat')

async function main() {
  const PointsDistribution = await ethers.getContractFactory(
    'PointsDistribution'
  )
  const pointsDistribution = await upgrades.upgradeProxy(
    '0x7bdd924e87f04354dbdac314b4b39e839403c0c1',
    PointsDistribution
  )
  console.log('upgraded')
}

main()
