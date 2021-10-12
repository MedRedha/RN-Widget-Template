import React from 'react';
import {StyleSheet, Text, View} from 'react-native';

const EthScreen = ({route}) => {
  const {ethPrice} = route.params;

  return (
    <View style={styles.container}>
      <Text style={{fontWeight: 'bold', fontSize: 18}}>ETH Price:</Text>
      <Text style={styles.ethInput}>{ethPrice}</Text>
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
    marginTop: 8,
    textAlign: 'center',
    fontWeight: 'bold',
    fontSize: 26,
  },
});

export default EthScreen;
