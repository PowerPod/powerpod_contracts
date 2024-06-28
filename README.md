## PowerPod

### Iotex

| Contract  | Address                                    |
| --------- | ------------------------------------------ |
| PPD Token | 0x90E8FC040b7D7d065F32844D22e7f00A9660dAb7 |

### Base Sepolia

| contract            | address                                    |
| ------------------- | ------------------------------------------ |
| ZKPass RWA NFT      | 0xeB0e05D4b4e4dF7c36a15EbB009fC18CA0f2944b |
| ZKPass RWA NFT Sale | 0xF927F99a87d291EA93eDce86AEe27202B1c0AF36 |

### Sepolia contract addresses

| contract                     | address                                    |
| ---------------------------- | ------------------------------------------ |
| PT Points Contract           | 0xAD32172b6B8860d3015FAeAbF289823453201568 |
| Points Distribution Contract | 0x7BDD924e87f04354DbDAc314b4b39e839403C0c1 |
| PPD Token Contract           | 0x7a1cbe287fd36a3423151a897B97693886BE667b |
| Token Distribution Contract  | 0x3981d326152E2C845f41Aea6DFC35E23234FF607 |
| Payment                      | 0xeE6393d237bc57223f9eEBDB7c9B9501737d0365 |
| ZKPass RWA NFT               | 0x344b074F8847C8cC8a9BeE76Ed179346151b0858 |

### Amoy testnet contract addresses

| contract                     | address                                    |
| ---------------------------- | ------------------------------------------ |
| PT Points Contract           | 0xd05f4e47be3f184841adcbbc518aea7991108ca3 |
| Points Distribution Contract |                                            |
| PPD Token Contract           |                                            |
| Token Distribution Contract  |                                            |

### Deploy and Verify contracts on Amoy

```bash
export PRIVATE_KEY=0x...
export OKLINK_API_KEY=...
export INFURA_API_KEY=...
```

- PT Points Contract

```bash
npx hardhat run --network sepolia script/DeployPTPoints.s.js
```

```bash
npx hardhat verify --network sepolia 0xAD32172b6B8860d3015FAeAbF289823453201568
```

## Here to claim some faucet USDT for tesing

https://staging.aave.com/faucet/
