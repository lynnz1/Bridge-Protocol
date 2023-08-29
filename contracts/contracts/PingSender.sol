// SPDX-License-Identifier: AGPL-3.0

pragma solidity 0.8.17;

import "./polygonZKEVMContracts/interfaces/IBridgeMessageReceiver.sol";
import "./polygonZKEVMContracts/interfaces/IPolygonZkEVMBridge.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * ZkEVMNFTBridge is an example contract to use the message layer of the PolygonZkEVMBridge to bridge NFTs
 */
contract PingSender is Ownable {

    bytes private _encodedMessage;

    struct Strategy { 
        string strategyName;
        uint256 apy;
    }

    struct Personal {
        string strategyName;
        uint256 investment;
        uint256 currentValue;
        uint256 percentage;
    }

    Strategy[] public strategies;
    
    // name: strategies : strategy details
    mapping (address => Personal[]) public personals;

    // Global Exit Root address
    IPolygonZkEVMBridge public immutable polygonZkEVMBridge;

    // Address in the other network that will receive the message
    address public pingReceiver;

    /**
     * @param _polygonZkEVMBridge Polygon zkevm bridge address
     */
    constructor(IPolygonZkEVMBridge _polygonZkEVMBridge) {
        polygonZkEVMBridge = _polygonZkEVMBridge;
    }

    /**
     * @dev Emitted when send a message to another network
     */
    event PingMessage(bytes message);

    /**
     * @dev Emitted when change the receiver
     */
    event SetReceiver(address newPingReceiver);

    function addToStrategies (string memory _name, uint256 _apy) public {
        strategies.push(Strategy(_name,_apy));
    }

    function addToUserRecords(address _user, string memory _strategyName, 
    uint256 _investment, uint256 _currentValue, uint256 _percentage) public {
        personals[_user].push(Personal(_strategyName, _investment, _currentValue, _percentage));
    }

    /**
     *  0 = personal message, 1 = strategy(public) message
     */
    function _personalMessageInit() private returns (bytes memory){
        bytes memory _temp = abi.encode(msg.sender, personals[msg.sender]);
        bytes memory _message = abi.encode(0,_temp);
        delete personals[msg.sender];
        return _message;
    }

    function _strategyMessageInit() private returns (bytes memory){
        bytes memory _temp = abi.encode(strategies);
        bytes memory _message = abi.encode(1,_temp);
        return _message;
    }
    /**
     * @notice Send a message to the other network
     * @param destinationNetwork Network destination
     * @param forceUpdateGlobalExitRoot Indicates if the global exit root is updated or not
     *  0 = personal message, 1 = strategy(public) message
     */
    function bridgePingMessage(
        uint32 destinationNetwork,
        bool forceUpdateGlobalExitRoot,
        uint256 selector
    ) public{
        //bytes memory pingMessage = abi.encode(pingValue);
        bytes memory pingMessage;
        if (selector == 0) {
            pingMessage = _personalMessageInit();
        } else if (selector == 1){
            pingMessage = _strategyMessageInit();
        }
        // Bridge ping message
        polygonZkEVMBridge.bridgeMessage(
            destinationNetwork,
            pingReceiver,
            forceUpdateGlobalExitRoot,
            pingMessage
        );
        emit PingMessage(pingMessage);
    }

    /**
     * @notice Set the receiver of the message
     * @param newPingReceiver Address of the receiver in the other network
     */
    function setReceiver(address newPingReceiver) external onlyOwner {
        pingReceiver = newPingReceiver;
        emit SetReceiver(newPingReceiver);
    }
}
