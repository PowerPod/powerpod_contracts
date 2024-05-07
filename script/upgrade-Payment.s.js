const { ethers, upgrades } = require('hardhat')

async function main() {
  const PaymentContract = await ethers.getContractFactory('PaymentContract')

  const paymentContract = await upgrades.upgradeProxy(
    '0xeE6393d237bc57223f9eEBDB7c9B9501737d0365',
    PaymentContract
  )
  console.log('upgraded')
}

main()
