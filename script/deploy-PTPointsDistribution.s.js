const { ethers, upgrades } = require('hardhat')

async function main() {
  const PointsDistribution = await ethers.getContractFactory(
    'PointsDistribution'
  )
  const pointsDistribution = await upgrades.deployProxy(PointsDistribution, [
    '0xad32172b6b8860d3015faeabf289823453201568',
  ])
  await pointsDistribution.waitForDeployment()
  console.log(
    'pointsDistribution deployed to:',
    await pointsDistribution.getAddress()
  )
}

main()
