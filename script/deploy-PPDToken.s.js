const hre = require('hardhat')

async function main() {
  const token = await hre.ethers.deployContract('PPDToken', [
    '1000000000000000000000000000',
    '0x7fDadA8376d9f369586Afc5F1C92db44c3a6d64A',
  ])

  await token.waitForDeployment()

  console.log(`Deployed to ${token.target}`)
}

main().catch((error) => {
  console.error(error)
  process.exitCode = 1
})
