
# Bridge-Protocol（跨链消息协议）

## 项目简介  
该项目为参与 **Polygon DevX Hackathon** 而开发，旨在实现一个基于 Polygon LxLy 跨链桥的跨链消息通信协议，帮助跨链 DeFi 应用高效传输各种结构化数据，并提供前端界面供用户查看相关信息。
本项目同时作为公司内部跨链消息系统的技术预研产物，参与 Hackathon 是为了探索 Polygon LxLy 技术在实际业务中的可行性与应用场景。

随着区块链生态和 DeFi 应用的快速增长，跨链传输**收益策略数据**的需求也日益增加。本项目通过自定义消息协议，使跨链应用不仅能够传输通用策略信息，还能**精准推送个性化数据至特定用户地址**，提升跨链智能合约的数据交互能力。

## 支持的功能与数据结构

### 1. **公开数据传输**（Public）  
适用于传输如收益策略名称、APY 等非敏感数据，所有用户看到的内容一致。  
我们为此提供了相关函数，支持开发者从源链发送此类共享信息。

### 2. **用户专属数据传输**（Private）  
适用于如用户投资金额、收益增长等个性化内容，仅目标用户地址可见。  
本模块支持合约层面上的用户专属数据访问控制和显示逻辑。

所有数据在源链智能合约中以数组形式存储，变量支持动态追加，具有较强扩展性。

## 合约部署地址

- Sender 合约（Goerli 测试网）：`0x653A5fF87E8570980C8AEE5CA7c54E7B4C89F235`  
- Receiver 合约（Polygon zkEVM 测试网）：`0x2834C606571d7C4A6Ff9051cd4F67cC12D12c76f`

## 本地部署说明

1. 进入 `contract` 文件夹，按照其中的说明部署合约  
2. 进入 `frontend` 文件夹，执行：

```bash
npm install
npm start
```

启动前端应用查看消息数据交互效果

## 技术亮点
- 基于 Polygon LxLy 实现链间消息通信机制
- 支持结构化数组数据的跨链传输与解析
- 实现用户级别的数据权限控制与显示逻辑
- 前后端联动，便于测试与演示协议功能

---

📂 项目为归档展示用，代码结构清晰，欢迎参考学习。


# Bridge-Protocol

## Project Introduction:
This project is a messaging protocols which developed to participate in the Polygon DevX Hackathon. \
This cross chain messaging contracts is created using the Polygon Lxly bridge. Helping cross chain Dapps to send array of data with various data structure and a user interface for users to view relavant data.\


This app is developed to facilitate the need of crosschain Defi apps. \
As the community of blockchains and Defi applications grows, the need for sending data of yielding strategies is growing. Cross chain Defi/Dapps not only has the need to send strategy related data, but been able to send data specifically to user addresses is also needed. Data is stored on the contract of the origin blockchain in the format of array. Variables are allowed to be added to these arrays at anytime. 

Supported data structure includes:
1. Data that is allowed to viewed by public.
   For this requirment we have developed functions that allow contract developers to send unsensible data. For example, some basic information about yielding strategies including the name and the APY of the strategy. Since data sent using this function is not personalized, therefore it is displayed the same for every user.  
   
2. Data that is restricted to be viewed by sepecific user.
   This functions allows personalized data to be sent and displayed. It is very useful when used to display information such as the investment amount, percentage of growth etc.


Contract address:

Sender contract developed on Goerli: 0x653A5fF87E8570980C8AEE5CA7c54E7B4C89F235

Receiver contract developed on PolygonZKevm testnet:0x2834C606571d7C4A6Ff9051cd4F67cC12D12c76f

## Deployment
Go to 'contract' folder, follow the instruction in 'readme'.
Go to 'frontend' folder, run 'npm install' and 'npm start' to start the application.


