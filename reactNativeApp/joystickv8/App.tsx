import { StatusBar } from 'expo-status-bar';
import { StyleSheet, Text, View } from 'react-native';
import { Joystick } from 'react-joystick-component';

export default function App() {
  return (
    <View style={styles.container}>
      <Text>Open up App.tsx to start working on your app teste!</Text>
      <Joystick size={100} sticky={true} baseColor="red" stickColor="blue"></Joystick>
      <StatusBar style="auto" />
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
