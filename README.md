## PowerPod


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
export ETHERSCAN_API_KEY=...
```

- PT Points Contract

```bash
forge script script/DeployPTPoints.s.sol --rpc-url polygon_amoy --private-key $PRIVATE_KEY --broadcast --verify 
```