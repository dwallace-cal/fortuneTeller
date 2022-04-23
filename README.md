# 🏗 Scaffold-ETH/fortuneTeller

🚀 MVP prototype for Aavegotchi FortuneTeller NPC! 🚀

🧪 Developed during #Chainlink Spring 2022 Hackathon 🧪

🎲 Verifiable Randomness with Chainlink VRF 🎲

![Aavegotchi](https://www.aavegotchi.com/img/brand/sun.png "Aavegotchi")
![ChainLink](https://docs.chain.link/files/a4c6c80-85d09b6-19facd8-banner.png)

# 📚 Documentation:
For use by Our P2E Guild, to provide guild content in-game. Designed to have upgradable contracts to update fortunes. Decentralized, server-less front end saved to IPFS. second phase will include use of price oracle to influence fortunes.


# 🏄‍♂️ Quick Start:

Prerequisites: [Node](https://nodejs.org/en/download/) plus [Yarn](https://classic.yarnpkg.com/en/docs/install/) and [Git](https://git-scm.com/downloads)

> clone/fork 🏗 scaffold-eth:

```bash
git clone https://github.com/scaffold-eth/scaffold-eth.git
```

> install and start your 👷‍ Hardhat chain:

```bash
cd scaffold-eth
yarn install
yarn chain
```

> in a second terminal window, start your 📱 frontend:

```bash
cd scaffold-eth
yarn start
```

> in a third terminal window, 🛰 deploy your contract:

```bash
cd scaffold-eth
yarn deploy
```

🔏 Edit your smart contract `YourContract.sol` in `packages/hardhat/contracts`

📝 Edit your frontend `App.jsx` in `packages/react-app/src`

💼 Edit your deployment scripts in `packages/hardhat/deploy`

📱 Open http://localhost:3000 to see the app



# 🛠 Buidl


# 💌 P.S.

🌍 You need an RPC key for testnets and production deployments, create an [Alchemy](https://www.alchemy.com/) account and replace the value of `ALCHEMY_KEY = xxx` in `packages/react-app/src/constants.js` with your new key.

### Automated with Gitpod

[![Open in Gitpod](https://gitpod.io/button/open-in-gitpod.svg)](https://gitpod.io/#github.com/scaffold-eth/scaffold-eth)