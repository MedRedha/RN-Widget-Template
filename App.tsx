import { NavigationContainer } from '@react-navigation/native';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import React from 'react';

import BtcScreen from './src/screens/BtcScreen';
import EthScreen from './src/screens/EthScreen';
import HomeScreen from './src/screens/HomeScreen';

const Stack = createNativeStackNavigator();

const RedhaWidget = () => {
  return (
    <NavigationContainer>
      <Stack.Navigator>
        <Stack.Screen
          name='Home Screen'
          component={HomeScreen}
          options={{
            headerShown: false,
          }}
        />
        <Stack.Screen
          name='BtcScreen'
          component={BtcScreen}
          initialParams={{ btcPrice: 0 }}
        />
        <Stack.Screen
          name='EthScreen'
          component={EthScreen}
          initialParams={{ ethPrice: 0 }}
        />
      </Stack.Navigator>
    </NavigationContainer>
  );
};

export default RedhaWidget;
