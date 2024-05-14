const hre = require('hardhat')

async function main() {
  const nft = await hre.ethers.deployContract('RWANFT', [
    'Tesla',
    'tsl',
    2000,
    'ipfs://QmdKCEXN8KVDSc5AtV1HnBCG9KztMKYwb3yg8P8js848g9',
  ])

  await nft.waitForDeployment()

  console.log(`Deployed to ${nft.target}`)
}

main().catch((error) => {
  console.error(error)
  process.exitCode = 1
})
