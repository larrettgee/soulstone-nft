# 🤓 Advanced NFT Mechanics

## ✅ TODO

- [x] Implement a merkle tree airdrop where addresses in the merkle tree are allowed to mint once.
- [ ] Measure the gas cost of using a mapping to track if an address already minted vs tracking each address with a bit in a bitmap. Hint: the merkle leaf should be the hash of the address and its index in the bitmap. Use the bitmaps from OpenZeppelin
- [ ] Use commit reveal to allocate NFT ids randomly. The reveal should be 10 blocks ahead of the commit. You can look at cool cats NFT to see how this is done. They use chainlink, but you should use commit-reveal.
- [x] Add multicall to the NFT so people can transfer several NFTs in one transaction (make sure people can’t abuse minting!)
- [x] The NFT should use a state machine to determine if it is mints can happen, the presale is active, or the public sale is active, or the supply has run out. Require statements should only depend on the state (except when checking input validity)
- [x] Designated address should be able to withdraw funds using the pull pattern. You should be able to withdraw to an arbitrary number of contributors

## 💪 Repo Features

- 🛠️ Fuzzing & Advanced Testing (w/ Foundry)
- 🤝 Integration & JS testing (w/ Hardhat)
- 🪖 Etherscan Verifications (w/ Hardhat)
- 🚀 Smooth Deployments (w/ Hardhat)
- 🛜 Example Network Config
- 🔥 Typescript & Ethers.js

## 🚗 Getting Started

1. Run `npm i`.
2. Copy `.env.example` as `.env`.
3. Run `forge install foundry-rs/forge-std`

## 🤝 Helpful Repo Commands

Hardhat

- `npx hardhat test` to test `.ts` files.
- `REPORT_GAS=true npx hardhat test`
- `npx hardhat ignition deploy ignition/modules/Lock.ts --network sepolia --deployment-id sepolia-deployment` to deploy specific contracts
- `npx hardhat ignition verify sepolia-deployment` to verify deployment with corresponding ID

Foundry

- `forge test` run Foundry tests
- `forge build` compile Foundry contracts
