# Bridging-Protocol contracts

## Deployment

In project root execute:

```
npm i
cp .env.example .env
```
(Fill `.env` with your `MNEMONIC` or `PVTKEY` )


Send a message: 

The 'selector' argument sent to 'bridgePingMessage' function determins whether to bridge a public message or a personalized message.
It can be changed inside 'bridgePing.js', line 32.

npm run bridge:bridgePing:goerli

Receiv a message:
1. Claim message
npm run claim:claimPong:polygonZKEVMTestnet

2. When message is successfully claimed, view messages with the frontend app.

