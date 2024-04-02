import { ScrollView, View, Text, StatusBar, } from "react-native";
import BluetoothListLayout from './app/bluetooth/containers'
import {Header, LearnMoreLinks, Colors, DebugInstructions, ReloadInstructions} from 'react-native/Libraries/NewAppScreen';
import { KorolJoystick } from "korol-joystick";
import { GestureHandlerRootView } from "react-native-gesture-handler";

<GestureHandlerRootView>
  <YourApp />
</GestureHandlerRootView>
export default function App () {
<KorolJoystick color="#06b6d4" radius={75} onMove={(data) => console.log(data)} />
}