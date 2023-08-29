import React from "react";
import { ethers } from "ethers";
import contractAddress from "../contracts/contract-address.json";
import PoLottoExchange from "../contracts/PoLottoExchangeABI.json"
import { NoWalletDetected } from "./NoWalletDetected";
import { ConnectWallet } from "./ConnectWallet";
import { DataDisplay } from "./DataDisplay";
import { Row, Col } from 'antd';
import { AccountBookOutlined } from '@ant-design/icons';


export class Dapp extends React.Component {
  constructor(props) {
    super(props);
    this.initialState = {
      selectedAddress: undefined,
      networkError: undefined,
    };
    this.state = this.initialState
  }

  render() {
    if (window.ethereum === undefined) {
      return <NoWalletDetected />;
    }

    if (!this.state.selectedAddress) {
      return (
        <ConnectWallet
          connectWallet={() => this._connectWallet()}
          networkError={this.state.networkError}
          dismiss={() => this._dismissNetworkError()}
        />
      );
    }


    return (
      <div className="container p-4" style={{
        display: 'flex',
        flexDirection: 'column',
        alignItems: 'center',
        width: '50%',
      }}>
        <div className="row" style={{ marginBottom: 15 }}>
          <Row>
            <Col span={24}>
              <div style={{ display: 'flex', marginBottom: 15 }}>
                <AccountBookOutlined style={{  fontSize : 28 }}/>
                <h5 style={{ marginLeft: 10 }}>
                  {this.state.selectedAddress}
                </h5>
              </div>
            </Col>
          </Row>
        </div>
        <DataDisplay />
      </div>
    );
  }

  componentWillUnmount() {
    this._stopPollingData();
  }

  async _connectWallet() {
    const [selectedAddress] = await window.ethereum.request({
      method: "eth_requestAccounts",
    });
    this._initialize(selectedAddress);
    window.ethereum.on("accountsChanged", ([newAddress]) => {
      this._stopPollingData();
      if (newAddress === undefined) {
        return this._resetState();
      }
      this._initialize(newAddress);
    });
  }

  _initialize(userAddress) {
    this.setState({
      selectedAddress: userAddress,
    });
    this._initializeEthers();
  }

  async _initializeEthers() {
    this._provider = new ethers.providers.Web3Provider(window.ethereum);
    this._poLotto = new ethers.Contract(
      contractAddress.Contract,
      PoLottoExchange,
      this._provider.getSigner(0)
    );
  }


  _stopPollingData() {
    clearInterval(this._pollDataInterval);
    this._pollDataInterval = undefined;
  }


  _dismissNetworkError() {
    this.setState({ networkError: undefined });
  }

  _getRpcErrorMessage(error) {
    if (error.data) {
      return error.data.message;
    }
    return error.message;
  }

  _resetState() {
    this.setState(this.initialState);
  }
}
