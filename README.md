## PowerPod

### Sepolia contract addresses
|  contract | address | 
|---|---|
| PT Points Contract | 0xAD32172b6B8860d3015FAeAbF289823453201568 |   
| Points Distribution Contract |  |   
| PPD Token Contract |  |   
| Token Distribution Contract |  | 

### Amoy testnet contract addresses
|  contract | address | 
|---|---|
| PT Points Contract | 0xd05f4e47be3f184841adcbbc518aea7991108ca3 |   
| Points Distribution Contract |  |   
| PPD Token Contract |  |   
| Token Distribution Contract |  | 


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