# Restaking DeFi

Simulates restaking flow: ETH → stETH → wstETH → Aave collateral.

## Author
Wildan Bimantoro

## Contracts

### Lido.sol
`submit()` - Stake ETH, receive stETH. Real Lido uses share-based system for rebasing rewards. This mock uses 1:1 ratio.

### WstETH.sol
`wrap()` / `unwrap()` - Convert stETH to wstETH (non-rebasing). More compatible with DeFi protocols. This mock uses 1:1 ratio.

### Aave.sol
`supply()` - Deposit token as collateral. Real Aave mints aTokens and enables borrowing.
`withdraw()` - Withdraw tokens from pool.

### RestakeManager.sol
`restake()` - Orchestrates full flow in one transaction: stake → wrap → supply.

## Flow
```
ETH → Lido.submit() → stETH → WstETH.wrap() → wstETH → Aave.supply()
```

## Deployed (Sepolia)

| Contract | Address |
|----------|---------|
| Lido | [0x519E7A687D483afF68e2749f758ce40fE04cE5f0](https://sepolia.etherscan.io/address/0x519E7A687D483afF68e2749f758ce40fE04cE5f0) |
| WstETH | [0x6627E7B4eFDA92cf64DFf89445754e6E32340716](https://sepolia.etherscan.io/address/0x6627E7B4eFDA92cf64DFf89445754e6E32340716) |
| Aave | [0xcdA22fbFbD07EEfd3D46D8CCd2EBb3B5ba5Ca524](https://sepolia.etherscan.io/address/0xcdA22fbFbD07EEfd3D46D8CCd2EBb3B5ba5Ca524) |
| RestakeManager | [0xB19F1cEC9D36f5b2EcA041b0E87E74D60131959f](https://sepolia.etherscan.io/address/0xB19F1cEC9D36f5b2EcA041b0E87E74D60131959f) |

## Setup

```bash
forge install
forge build
forge test
```

## Deploy

```bash
# fill .env with PRIVATE_KEY
source .env && forge script script/Deploy.s.sol:DeployScript --rpc-url https://ethereum-sepolia-rpc.publicnode.com --broadcast
```

## Real Contracts Reference
- Lido: [0xae7ab96520DE3A18E5e111B5EaAb095312D7fE84](https://etherscan.io/address/0xae7ab96520DE3A18E5e111B5EaAb095312D7fE84)
- WstETH: [0x7f39C581F595B53c5cb19bD0b3f8dA6c935E2Ca0](https://etherscan.io/address/0x7f39C581F595B53c5cb19bD0b3f8dA6c935E2Ca0)
- Aave V3: [0x87870Bca3F3fD6335C3F4ce8392D69350B4fA4E2](https://etherscan.io/address/0x87870Bca3F3fD6335C3F4ce8392D69350B4fA4E2)
