# ๐ Scaffold-ETH/fortuneTeller

๐ MVP prototype for Aavegotchi side-quest NPCs! ๐

๐งช Developed during #Chainlink Spring 2022 Hackathon ๐งช

๐ฒ Verifiable Randomness with Chainlink VRF ๐ฒ

![Aavegotchi](https://www.aavegotchi.com/img/brand/sun.png "Aavegotchi")
![ChainLink](https://docs.chain.link/files/a4c6c80-85d09b6-19facd8-banner.png)

# ๐ Documentation:
For use by our esports Guild, to provide guild content in-game such as side-quests via NPCs on guild lands. Designed to be upgradable in order to update fortunes based on current, in-game events. Decentralized, server-less front-end to be hosted on IPFS. second phase will include use of price oracle to influence fortunes. adaptabable, for future use cases such as to mint collectable ERC1155's for raffles or lottery. Accepts the utility tokens of Aavegotchi, called Alchemica. ($KEK, $ALPHA, $FOMO, $FUD)

Our Citadel NPC, known as "the Oraacle" (insert matrix-gotchi meme?) will plug in her Link cube and read your fortune, for a few Alchemica that is. Unfortunately, her cryptic predictions are hard to decipher. Party up with frens and venture out to the Grid to find the mythical LickSLayr (NPC#2). Rumor has it, he can tell us what it all means. But aalpha seekers beware -- lickquidators are lurking in every corner. Those that survive will have the chance to fulfill their quest, and be rewarded for their risk seeking behavior: Soulbound NFT's that allow for certain access rights at Guild outposts, farms, and installations. I hear the Oraacle is known to prefer $KEK...

Beacon ---> proxy for NPC #1 ---> Implementation
            proxy for NPC #2 ---> ERC721 x4

# ๐โโ๏ธ Quick Start:

Prerequisites: [Node](https://nodejs.org/en/download/) plus [Yarn](https://classic.yarnpkg.com/en/docs/install/) and [Git](https://git-scm.com/downloads)

> clone/fork ๐ scaffold-eth:

```bash
git clone https://github.com/dwallace-cal/fortuneTeller.git
```

> install and start your ๐ทโ Hardhat chain:

```bash
cd scaffold-eth
yarn install
yarn chain
```

> in a second terminal window, start your ๐ฑ frontend:

```bash
cd scaffold-eth
yarn start
```

> in a third terminal window, ๐ฐ deploy your contract:

```bash
cd scaffold-eth
yarn deploy
```

๐ Edit your smart contract `YourContract.sol` in `packages/hardhat/contracts`

๐ Edit your frontend `App.jsx` in `packages/react-app/src`

๐ผ Edit your deployment scripts in `packages/hardhat/deploy`

๐ฑ Open http://localhost:3000 to see the app



# ๐? Buidl


# ๐ P.S.

๐ You need an RPC key for testnets and production deployments, create an [Alchemy](https://www.alchemy.com/) account and replace the value of `ALCHEMY_KEY = xxx` in `packages/react-app/src/constants.js` with your new key.
