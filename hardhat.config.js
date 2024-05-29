require('@nomicfoundation/hardhat-toolbox')
require('@nomicfoundation/hardhat-foundry')
require('@nomicfoundation/hardhat-verify')
require('@openzeppelin/hardhat-upgrades')

/** @type import('hardhat/config').HardhatUserConfig */

require('dotenv').config()

const INFURA_API_KEY = process.env.INFURA_API_KEY
const PPD_PRIVATE_KEY = process.env.PPD_PRIVATE_KEY
const OKLINK_API_KEY = process.env.OKLINK_API_KEY
const ETHERSCAN_API_KEY = process.env.ETHERSCAN_API_KEY
const BASE_SEPOLIA_EXPLORER_API_KEY = process.env.BASE_SEPOLIA_EXPLORER_API_KEY
const ALCHEMY_BASE_SEPOLIA_API_KEY = process.env.ALCHEMY_BASE_SEPOLIA_API_KEY
const ALCHEMY_BASE_API_KEY = process.env.ALCHEMY_BASE_API_KEY

module.exports = {
  solidity: '0.8.20',

  networks: {
    amoy: {
      url: `https://polygon-amoy.infura.io/v3/${INFURA_API_KEY}`,
      accounts: [PPD_PRIVATE_KEY],
    },
    sepolia: {
      url: `https://sepolia.infura.io/v3/${INFURA_API_KEY}`,
      accounts: [PPD_PRIVATE_KEY],
    },
    base_sepolia: {
      url: `https://base-sepolia.g.alchemy.com/v2/${ALCHEMY_BASE_SEPOLIA_API_KEY}`,
      accounts: [PPD_PRIVATE_KEY],
    },
    base: {
      url: `https://base-mainnet.g.alchemy.com/v2/${ALCHEMY_BASE_API_KEY}`,
      accounts: [PPD_PRIVATE_KEY],
    },
  },
  etherscan: {
    apiKey: {
      amoy: `${OKLINK_API_KEY}`,
      sepolia: `${ETHERSCAN_API_KEY}`,
      base_sepolia: `${BASE_SEPOLIA_EXPLORER_API_KEY}`,
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
      {
        network: 'base_sepolia',
        chainId: 84532,
        urls: {
          apiURL: 'https://base-sepolia.blockscout.com/api',
          browserURL: 'https://base-sepolia.blockscout.com',
        },
      },
    ],
  },
}
