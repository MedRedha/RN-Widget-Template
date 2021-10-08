import React, {useEffect, useState} from 'react';
import {StyleSheet, Text, View} from 'react-native';
import SharedGroupPreferences from 'react-native-shared-group-preferences';
import BackgroundTimer from 'react-native-background-timer';

const appGroupIdentifier = 'group.com.wuud-team.redhawidget';

const RedhaWidget = () => {
  const [btcPrice, setBtcPrice] = useState<string>('0');
  const [ethPrice, setEthPrice] = useState<string>('0');

  const fetchAndSendData = () => {
    const bitcoinPrice =
      (Math.random() * 100000)
        .toFixed(2)
        .toString()
        .replace(/\B(?=(\d{3})+(?!\d))/g, ',') + ' €';
    setBtcPrice(bitcoinPrice);

    const ethereumPrice =
      (Math.random() * 10000)
        .toFixed(2)
        .toString()
        .replace(/\B(?=(\d{3})+(?!\d))/g, ',') + ' €';
    setEthPrice(ethereumPrice);

    //! passing data through the native bridge
    passValues({btcPrice: bitcoinPrice}).then(() => console.log(bitcoinPrice));
  };

  useEffect(() => {
    BackgroundTimer.start();

    setInterval(() => {
      fetchAndSendData();
    }, 5000);
  }, []);

  const passValues = async (widgetData) => {
    try {
      await SharedGroupPreferences.setItem(
        'savedData',
        widgetData,
        appGroupIdentifier
      );
    } catch (error) {
      return null;
    }
  };

  return (
    <View style={styles.container}>
      <Text>BTC Price:</Text>
      <Text style={styles.input}>{btcPrice}</Text>
      <Text>ETH Price:</Text>
      <Text style={styles.input}>{ethPrice}</Text>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    paddingHorizontal: 32,
    justifyContent: 'center',
    backgroundColor: '#ffffff',
  },
  input: {
    height: 40,
    width: '100%',
    marginTop: 16,
    textAlign: 'center',
    fontWeight: 'bold',
    fontSize: 20,
  },
});

export default RedhaWidget;
