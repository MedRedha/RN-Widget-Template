import { useIsFocused } from '@react-navigation/native';
import React, { useEffect, useState } from 'react';
import { ImageBackground, StyleSheet, Text, View } from 'react-native';
import BackgroundTimer from 'react-native-background-timer';
import { Button, Overlay } from 'react-native-elements';
import SharedGroupPreferences from 'react-native-shared-group-preferences';
import BtcIcon from 'react-native-vector-icons/FontAwesome';
import EthIcon from 'react-native-vector-icons/MaterialCommunityIcons';

const appGroupIdentifier = 'group.com.wuud-team.redhawidget';

const HomeScreen = ({ navigation }) => {
  const isFocused = useIsFocused();
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
    passValues({ btcPrice: bitcoinPrice, ethPrice: ethereumPrice }).then(() =>
      // eslint-disable-next-line no-console
      console.log(bitcoinPrice)
    );
  };

  useEffect(() => {
    BackgroundTimer.start();
    setInterval(() => fetchAndSendData(), 5000);
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
      <ImageBackground
        source={require('./../../assets/Nuri.png')}
        resizeMode='cover'
        style={styles.image}>
        <Overlay isVisible={isFocused} overlayStyle={styles.overlay}>
          <Text style={{ fontWeight: 'bold', color: 'white', fontSize: 18 }}>
            BTC Price:
          </Text>
          <Text style={styles.btcInput}>{btcPrice}</Text>
          <Text style={{ fontWeight: 'bold', color: 'white', fontSize: 18 }}>
            ETH Price:
          </Text>
          <Text style={styles.ethInput}>{ethPrice}</Text>
          <View style={styles.buttons}>
            <Button
              icon={
                <BtcIcon
                  name='btc'
                  size={22}
                  color='white'
                  style={{ marginRight: 10 }}
                />
              }
              title='Bitcoin'
              onPress={() => {
                navigation.navigate('BtcScreen', {
                  btcPrice: btcPrice,
                });
              }}
            />
            <Button
              icon={
                <EthIcon
                  name='ethereum'
                  size={22}
                  color='white'
                  style={{ marginRight: 10 }}
                />
              }
              title='Ethereum'
              onPress={() => {
                navigation.navigate('EthScreen', {
                  ethPrice: ethPrice,
                });
              }}
            />
          </View>
        </Overlay>
      </ImageBackground>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  image: {
    flex: 1,
    width: '100%',
  },
  overlay: {
    width: '100%',
    height: 250,
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: 'transparent',
  },
  buttons: {
    flex: 1,
    width: '80%',
    alignItems: 'center',
    justifyContent: 'space-evenly',
    flexDirection: 'row',
  },
  btcInput: {
    marginBottom: 22,
    textAlign: 'center',
    fontWeight: 'bold',
    fontSize: 26,
    color: 'white',
  },
  ethInput: {
    textAlign: 'center',
    fontWeight: 'bold',
    fontSize: 26,
    color: 'white',
    marginBottom: 22,
  },
});

export default HomeScreen;
