import React from "react";
import { ethers } from "ethers";
import { Card, Table } from 'antd';
import contractAddress from "../contracts/contract-address.json";
import PoLottoExchange from "../contracts/PoLottoExchangeABI.json"

export class DataDisplay extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      strategiesData: [],
      personalData: []
    };
  }

  componentDidMount() {
    this.fetchData();
  }

  fetchData = async () => {
    const strategiesData = [];
    const personalData = [];
    this._provider = new ethers.providers.Web3Provider(window.ethereum);
    this._poLotto = new ethers.Contract(
      contractAddress.Contract,
      PoLottoExchange,
      this._provider.getSigner(0)
    );
    const data = await this._poLotto.viewStrategies();
    console.log(data);
    data.forEach((item, index) => {
      const strategyName = item[0].toString()
      const apy = item[1].toString();
      const newData = {
        key: index,
        strategyName,
        apy: ethers.utils.formatUnits(ethers.BigNumber.from(apy), 18),
      };
      strategiesData[index] = newData;
    });
    const data1 = await this._poLotto.viewPersonal();
    data1.forEach((item, index) => {
      const strategyName = item[0].toString()
      const investment = item[1].toString()
      const currentValue = item[2].toString()
      const percentage = item[3].toString();
      const newData1 = {
        key: index,
        strategyName,
        investment: ethers.utils.formatUnits(ethers.BigNumber.from(investment), 18),
        currentValue: ethers.utils.formatUnits(ethers.BigNumber.from(currentValue), 18),
        percentage: ethers.utils.formatUnits(ethers.BigNumber.from(percentage), 18),
      };
      personalData[index] = newData1;
    });
    this.setState({ strategiesData, personalData });
  }

  render() {
    const strategiesColumns = [
      {
        title: 'Strategy Name',
        dataIndex: 'strategyName',
        key: 'strategyName',
        align: 'center',
      },
      {
        title: 'Apy(%)',
        dataIndex: 'apy',
        key: 'apy',
        align: 'center',
      }
    ];
    const personalColumns = [
      {
        title: 'Strategy Name',
        dataIndex: 'strategyName',
        key: 'strategyName',
        align: 'center',
      },
      {
        title: 'Investment',
        dataIndex: 'investment',
        key: 'investment',
        align: 'center',
      },
      {
        title: 'Current Value',
        dataIndex: 'currentValue',
        key: 'currentValue',
        align: 'center',
      },
      {
        title: 'Percentage(%)',
        dataIndex: 'percentage',
        key: 'percentage',
        align: 'center',
      }
    ];

    return (
      <Card>
        <h2>Strategies</h2>
        <Table style={{ marginTop: 50 }} dataSource={this.state.strategiesData} columns={strategiesColumns} />
        <h2>My Strategies</h2>
        <Table style={{ marginTop: 50 }} dataSource={this.state.personalData} columns={personalColumns} />
      </Card>
    );
  }
}