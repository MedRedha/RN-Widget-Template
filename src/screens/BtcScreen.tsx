import React from 'react';
import { StyleSheet, Text, View } from 'react-native';

const BtcScreen = ({ route }) => {
  const { btcPrice } = route.params;

  return (
    <View style={styles.container}>
      <Text style={{ fontWeight: 'bold', fontSize: 18 }}>BTC Price:</Text>
      <Text style={styles.btcInput}>{btcPrice}</Text>
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
  btcInput: {
    marginTop: 8,
    textAlign: 'center',
    fontWeight: 'bold',
    fontSize: 26,
  },
});

export default BtcScreen;
