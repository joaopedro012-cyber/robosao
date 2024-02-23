/* import { StatusBar } from 'expo-status-bar';
import { StyleSheet, Text, View } from 'react-native';
import { Joystick } from 'react-joystick-component';
import BleManager from 'react-native-ble-manager';

export default function App() {
  return (
    <View style={styles.container}>
      <Text>Open up App.tsx to start working on your app!tteste</Text>
      <StatusBar style="auto" />
      <Joystick
  move={(event) => {
    // O objeto de evento contém informações sobre a direção do joystick
    const direction = event.direction;

    if (direction === 'FORWARD') {
      // Se o joystick for empurrado para frente, envie o caractere 'w'
      let peripheralId: string = '98:D3:51:F6:38:28';
      let serviceUUID: string = '00001101-0000-1000-8000-00805F9B34FB';
      let characteristicUUID: string = 'characteristicUUID aqui';
      let data: number[] = [0]; // os dados que você deseja enviar

BleManager.write(peripheralId, serviceUUID, characteristicUUID, data)
  .then(() => {
    console.log('Dado enviado');
  })
  .catch((error) => {
    console.log('Erro ao enviar dado: ', error);
  });
    }
  }}
/>

    </View>
    
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
    alignItems: 'center',
    justifyContent: 'center',
  },
});
 */

import * as React from 'react';
import { View } from 'react-native';
import { Joystick } from 'react-joystick-component';

type JoystickDirection = "FORWARD" | "RIGHT" | "LEFT" | "BACKWARD";

export interface IJoystickUpdateEvent {
    type: "move" | "stop" | "start";
    x: number | null;
    y: number | null;
    direction: JoystickDirection | null;
    distance: number; // Percentile 0-100% of joystick 
}

() => <Joystick start={action("Started")} move={action("Moved")}
                                                        stop={action("Stopped")}/>