// SPDX-License-Identifier: AGPL-3.0

pragma solidity 0.8.17;

import "./polygonZKEVMContracts/interfaces/IBridgeMessageReceiver.sol";
import "./polygonZKEVMContracts/interfaces/IPolygonZkEVMBridge.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * ZkEVMNFTBridge is an example contract to use the message layer of the PolygonZkEVMBridge to bridge NFTs
 */
contract PingReceiver is IBridgeMessageReceiver, Ownable {

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

    // Current network identifier
    uint32 public immutable networkID;

    // Address in the other network that will send the message
    address public pingSender;

    // Value sent from the other network
    uint256 public pingValue;

    /**
     * @param _polygonZkEVMBridge Polygon zkevm bridge address
     */
    constructor(IPolygonZkEVMBridge _polygonZkEVMBridge) {
        polygonZkEVMBridge = _polygonZkEVMBridge;
        networkID = polygonZkEVMBridge.networkID();
    }

    /**
     * @dev Emitted when a message is received from another network
     */
    event PingReceived(uint256 pingValue);

    /**
     * @dev Emitted when change the sender
     */
    event SetSender(address newPingSender);

    function viewStrategies() public view returns (Strategy[] memory) {
        return strategies;
    }

    function viewPersonal() public view returns (Personal[] memory) {
        return personals[msg.sender];
    }
    
    function _decodeBytes(bytes memory _data) private {
        (uint _id, bytes memory b) = abi.decode(_data,(uint, bytes));
        if (_id == 0) {
            (address _add, Personal[] memory _personal) = abi.decode(b,(address, Personal[]));
            for (uint i = 0; i < _personal.length; i++) 
            {
                personals[_add].push(_personal[i]);
            }
        } else if(_id == 1){
            (Strategy[] memory _strat) = abi.decode(b,(Strategy[]));
            for (uint i = 0; i < _strat.length; i++) 
            {
                strategies.push(_strat[i]);
            }
        }
    }
    /**
     * @notice Set the sender of the message
     * @param newPingSender Address of the sender in the other network
     */
    function setSender(address newPingSender) external onlyOwner {
        pingSender = newPingSender;
        emit SetSender(newPingSender);
    }

    /**
     * @notice Verify merkle proof and withdraw tokens/ether
     * @param originAddress Origin address that the message was sended
     * @param originNetwork Origin network that the message was sended ( not usefull for this contract)
     * @param data Abi encoded metadata
     */
    function onMessageReceived(
        address originAddress,
        uint32 originNetwork,
        bytes memory data
    ) external payable override {
        // Can only be called by the bridge
        require(
            msg.sender == address(polygonZkEVMBridge),
            "PingReceiver::onMessageReceived: Not PolygonZkEVMBridge"
        );

        // Can only be called by the sender on the other network
        require(
            pingSender == originAddress,
            "PingReceiver::onMessageReceived: Not ping Sender"
        );

        // Decode data
        //pingValue = abi.decode(data, (uint256));
        _decodeBytes(data);

        //emit PingReceived(data);
    }
}
