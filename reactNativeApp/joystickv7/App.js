import { StyleSheetheet, Text, View} from 'react-native';
import logo from './src/logo.svg';
import './src/App.css';
import './src/containers/bluetooth-list'
import BluetoothList from './src/containers/bluetooth-list';



function App() {
  return (

    <View>
        
        <BluetoothList/>
    </View>
  );
}

export default App;
