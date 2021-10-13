import React from 'react';
import { StyleSheet, Text, View } from 'react-native';
import BtcIcon from 'react-native-vector-icons/FontAwesome';

const BtcScreen = () => {
  return (
    <View style={styles.container}>
      <BtcIcon
        name='btc'
        size={52}
        color='orange'
        style={{ marginRight: 10 }}
      />
      <Text style={styles.btcInput}>This is the Bitcoin Screen</Text>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    paddingHorizontal: 50,
    justifyContent: 'center',
    backgroundColor: '#ffffff',
  },
  btcInput: {
    textAlign: 'center',
    fontWeight: 'bold',
    fontSize: 26,
  },
});

export default BtcScreen;
