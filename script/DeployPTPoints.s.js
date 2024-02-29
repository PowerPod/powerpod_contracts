const hre = require('hardhat')

async function main() {
  const ptPoints = await hre.ethers.deployContract('PTPoints')

  await ptPoints.waitForDeployment()

  console.log(`Deployed to ${ptPoints.target}`)
}

main().catch((error) => {
  console.error(error)
  process.exitCode = 1
})
