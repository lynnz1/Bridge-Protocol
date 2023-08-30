# Bridge-Protocol
Project Introduction:
This project is a messaging protocols which developed to participate in the Polygon DevX Hackathon. 
This cross chain messaging contracts is created using the Polygon Lxly bridge. Helping cross chain Dapps to send array of data with various data structure and a user interface for users to view relavant data.


This app is developed to facilitate the need of crosschain Defi apps. 
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


