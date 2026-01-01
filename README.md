# Restaking DeFi Simulation

A simplified implementation of the restaking flow in DeFi using Foundry. This project simulates how assets move between protocols when ETH is restaked through Lido, WstETH, and Aave.

## Author

- Wildan Bimantoro

## Contracts Overview

### 1. Lido.sol - Liquid Staking

**Key Function: `submit(address _referral)`**

The `submit()` function allows users to stake ETH and receive stETH (staked ETH) tokens in return. In the real Lido contract, this function calculates shares based on the total pooled ETH and the user's deposit, implementing a rebasing mechanism where stETH balance grows over time as staking rewards accrue. Our mock contract simplifies this by minting stETH at a 1:1 ratio with the deposited ETH, making it easier to understand the core staking flow without the complexity of share calculations.

### 2. WstETH.sol - Wrapped stETH

**Key Functions: `wrap(uint256 _stETHAmount)` and `unwrap(uint256 _wstETHAmount)`**

The `wrap()` function converts stETH to wstETH (wrapped stETH), which is a non-rebasing token that's more compatible with DeFi protocols. The real wstETH contract uses a share-based conversion rate that changes over time as staking rewards accumulate. Our mock uses a simplified 1:1 conversion rate. The `unwrap()` function reverses this process, allowing users to convert wstETH back to stETH.

### 3. Aave.sol - Lending Protocol

**Key Functions: `supply(address token, uint256 amount, address onBehalfOf)` and `withdraw(address token, uint256 amount)`**

The `supply()` function allows users to deposit tokens as collateral into the lending pool. The real Aave V3 contract mints aTokens (yield-bearing tokens) to represent the user's position and enables borrowing against the collateral. Our mock tracks supplied balances without implementing the full lending/borrowing mechanics. The `withdraw()` function allows users to retrieve their supplied tokens from the pool.

### 4. RestakeManager.sol - Orchestrator

**Key Function: `restake()`**

The `restake()` function orchestrates the complete restaking flow in a single transaction: (1) stake ETH in Lido to receive stETH, (2) wrap stETH into wstETH, and (3) supply wstETH to Aave as collateral. This demonstrates how DeFi composability allows users to earn staking yields while simultaneously using their assets as lending collateral.

## Restaking Flow

```
ETH → Lido.submit() → stETH → WstETH.wrap() → wstETH → Aave.supply() → Collateral Position
```

## Deployed Contracts (Sepolia Testnet)

| Contract | Address |
|----------|---------|
| Lido | [0x519E7A687D483afF68e2749f758ce40fE04cE5f0](https://sepolia.etherscan.io/address/0x519E7A687D483afF68e2749f758ce40fE04cE5f0) |
| WstETH | [0x6627E7B4eFDA92cf64DFf89445754e6E32340716](https://sepolia.etherscan.io/address/0x6627E7B4eFDA92cf64DFf89445754e6E32340716) |
| Aave | [0xcdA22fbFbD07EEfd3D46D8CCd2EBb3B5ba5Ca524](https://sepolia.etherscan.io/address/0xcdA22fbFbD07EEfd3D46D8CCd2EBb3B5ba5Ca524) |
| RestakeManager | [0xB19F1cEC9D36f5b2EcA041b0E87E74D60131959f](https://sepolia.etherscan.io/address/0xB19F1cEC9D36f5b2EcA041b0E87E74D60131959f) |

## Installation

```bash
# Clone the repository
git clone https://github.com/YOUR_USERNAME/restaking-defi.git
cd restaking-defi

# Install dependencies
forge install
```

## Usage

### Build

```bash
forge build
```

### Test

```bash
forge test -vvv
```

### Deploy to Testnet

1. Copy `.env` file dan isi private key Anda:
```bash
# Edit file .env dan ganti your_private_key_here dengan private key Anda
PRIVATE_KEY=your_private_key_here
```

2. Deploy dengan salah satu command berikut:
```bash
# Deploy to Sepolia
source .env && forge script script/Deploy.s.sol:DeployScript --rpc-url $SEPOLIA_RPC_URL --broadcast

# Or deploy to Base Sepolia
source .env && forge script script/Deploy.s.sol:DeployScript --rpc-url $BASE_SEPOLIA_RPC_URL --broadcast

# Or deploy to Polygon Amoy
source .env && forge script script/Deploy.s.sol:DeployScript --rpc-url $POLYGON_AMOY_RPC_URL --broadcast
```

## Real Contract Research

### Lido (Mainnet)
- Contract: [0xae7ab96520DE3A18E5e111B5EaAb095312D7fE84](https://etherscan.io/address/0xae7ab96520DE3A18E5e111B5EaAb095312D7fE84)
- The real `submit()` function uses a share-based system where stETH is a rebasing token

### WstETH (Mainnet)
- Contract: [0x7f39C581F595B53c5cb19bD0b3f8dA6c935E2Ca0](https://etherscan.io/address/0x7f39C581F595B53c5cb19bD0b3f8dA6c935E2Ca0)
- Wrapping uses `stETH.getSharesByPooledEth()` for accurate share conversion

### Aave V3 Pool (Mainnet)
- Contract: [0x87870Bca3F3fD6335C3F4ce8392D69350B4fA4E2](https://etherscan.io/address/0x87870Bca3F3fD6335C3F4ce8392D69350B4fA4E2)
- The real `supply()` function mints aTokens and updates user's health factor

## License

MIT
