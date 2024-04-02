import { StatusBar } from 'expo-status-bar';
import { StyleSheet, Text, View } from 'react-native';
import { GestureHandlerRootView } from "react-native-gesture-handler";
import { KorolJoystick } from "korol-joystick";

export default function App() {
  return (
    <View style={styles.container}>
      <GestureHandlerRootView>
        <KorolJoystick color="#06b6d4" radius={75} onMove={(data) => console.log(data)} />
      </GestureHandlerRootView>
    
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
