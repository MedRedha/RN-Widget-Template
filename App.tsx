import { NavigationContainer } from '@react-navigation/native';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import React from 'react';
import { Text } from 'react-native';

import BtcScreen from './src/screens/BtcScreen';
import EthScreen from './src/screens/EthScreen';
import HomeScreen from './src/screens/HomeScreen';

const Stack = createNativeStackNavigator();

const RedhaWidget = () => {
  const config = {
    screens: {
      BtcScreen: 'btc',
      EthScreen: 'eth',
    },
  };

  const linking = {
    prefixes: ['https://nuriwidget.com', 'nuriwidget://'],
    config,
  };

  return (
    <NavigationContainer linking={linking} fallback={<Text>Loading...</Text>}>
      <Stack.Navigator>
        <Stack.Screen
          name='HomeScreen'
          component={HomeScreen}
          options={{
            headerShown: false,
          }}
        />
        <Stack.Screen name='BtcScreen' component={BtcScreen} />
        <Stack.Screen name='EthScreen' component={EthScreen} />
      </Stack.Navigator>
    </NavigationContainer>
  );
};

export default RedhaWidget;
