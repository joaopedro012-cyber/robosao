import { BleManager } from 'react-native-ble-plx';
import React from 'react';
import { StyleSheet, Text, View, PermissionsAndroid} from 'react-native';

const manager = new BleManager();

class BluetoothConexao1 extends React.Component {
  componentDidMount() {
    this.scanForDevices();
  }

  scanForDevices = async () => {
    try {
      const granted = await PermissionsAndroid.request(
        PermissionsAndroid.PERMISSIONS.ACCESS_FINE_LOCATION,
        {
          title: 'Bluetooth Permission',
          message: 'This app requires access to your device`s Bluetooth.',
          buttonNeutral: 'Ask Me Later',
          buttonNegative: 'Cancel',
          buttonPositive: 'OK',
        },
      );

      if (granted === PermissionsAndroid.RESULTS.GRANTED) {
        const manager: BleManager = new BleManager(); // Inicialize o gerenciador de Bluetooth
        manager.startDeviceScan(null, null, (error: any, device: any) => {
          if (error) {
            console.error(error);
            return;
          }
          console.log('Device found:', device.name);
        });
      } else {
        console.log('Bluetooth permission denied.');
      }
    } catch (error) {
      console.error(error);
    }
  };
}

export default BluetoothConexao1;