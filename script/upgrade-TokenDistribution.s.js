const { ethers, upgrades } = require('hardhat')

async function main() {
  const TokenDistribution = await ethers.getContractFactory('TokenDistribution')
  const tokenDistribution = await upgrades.upgradeProxy(
    '0x3981d326152E2C845f41Aea6DFC35E23234FF607',
    TokenDistribution
  )
  console.log('upgraded')
}

main()
