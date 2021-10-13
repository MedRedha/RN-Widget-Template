import React from 'react';
import { StyleSheet, Text, View } from 'react-native';
import EthIcon from 'react-native-vector-icons/MaterialCommunityIcons';

const EthScreen = () => {
  return (
    <View style={styles.container}>
      <EthIcon
        name='ethereum'
        size={70}
        color='black'
        style={{ marginRight: 10 }}
      />
      <Text style={styles.ethInput}>This is the Ethereum Screen</Text>
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
  ethInput: {
    textAlign: 'center',
    fontWeight: 'bold',
    fontSize: 26,
  },
});

export default EthScreen;
