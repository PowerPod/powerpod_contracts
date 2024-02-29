require('@nomicfoundation/hardhat-toolbox')
require('@nomicfoundation/hardhat-foundry')
require('@nomicfoundation/hardhat-verify')
require('@openzeppelin/hardhat-upgrades')

/** @type import('hardhat/config').HardhatUserConfig */

require('dotenv').config()

const INFURA_API_KEY = process.env.INFURA_API_KEY
const PRIVATE_KEY = process.env.PRIVATE_KEY
const OKLINK_API_KEY = process.env.OKLINK_API_KEY
const ETHERSCAN_API_KEY = process.env.ETHERSCAN_API_KEY

module.exports = {
  solidity: '0.8.20',

  networks: {
    amoy: {
      url: `https://polygon-amoy.infura.io/v3/${INFURA_API_KEY}`,
      accounts: [PRIVATE_KEY],
    },
    sepolia: {
      url: `https://sepolia.infura.io/v3/${INFURA_API_KEY}`,
      accounts: [PRIVATE_KEY],
    },
  },
  etherscan: {
    apiKey: {
      amoy: `${OKLINK_API_KEY}`,
      sepolia: `${ETHERSCAN_API_KEY}`,
    },
    customChains: [
      {
        network: 'amoy',
        chainId: 80002,
        urls: {
          apiURL:
            'https://www.oklink.com/api/explorer/v1/contract/verify/async/api/amoy',
          browserURL: 'https://www.oklink.com/amoy',
        },
      },
    ],
  },
}
