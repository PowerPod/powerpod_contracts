const { ethers, upgrades } = require('hardhat')

async function main() {
  const PaymentContract = await ethers.getContractFactory('PaymentContract')
  // polygon mannet USDT 0xc2132D05D31c914a87C6611C10748AEb04B58e8F
  const paymentContract = await upgrades.deployProxy(PaymentContract, [
    '0xaA8E23Fb1079EA71e0a56F48a2aA51851D8433D0',
    '0xad32172b6b8860d3015faeabf289823453201568',
  ])
  await paymentContract.waitForDeployment()
  console.log(
    'paymentContract deployed to:',
    await paymentContract.getAddress()
  )
}

main()
