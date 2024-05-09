import { StatusBar } from 'expo-status-bar';
import AppLoading from "expo-app-loading";
import { StyleSheet, Text, View } from 'react-native';
import { useFonts, Poppins_300Light, Poppins_400Regular, Poppins_500Medium, Poppins_700Bold, Poppins_800ExtraBold,} from "@expo-google-fonts/poppins";
import { DMSans_400Regular } from '@expo-google-fonts/dm-sans';
import { DMSerifDisplay_400Regular } from '@expo-google-fonts/dm-serif-display';
import { ThemeProvider } from "styled-components";
import  COLORS from "./src/styles/theme";

const App: React.FC = () => {
  const [fontsLoaded] = useFonts({
    Poppins_300Light,
    Poppins_400Regular,
    Poppins_500Medium,
    Poppins_700Bold,
    Poppins_800ExtraBold,
    DMSans_400Regular,
    DMSerifDisplay_400Regular
  })
  if (!fontsLoaded) {
    return (
    <View
    style={{
      flex: 1,
      justifyContent: "center",
      alignItems: "center"
    }}>
    <Text>Falha no carregamento da font</Text>
    </View>
    )
  }
  
  return (
    <ThemeProvider theme={COLORS}>
      <StatusBar style="dark" translucent backgroundColor='transparent' />
    <View
      style={{
        flex: 1,
        justifyContent: "center",
        alignItems: "center",
        backgroundColor: COLORS.COLORS.ATTENTION_LIGHT2,
      }}
      >
        <Text>ControleBluetooth</Text>
      </View>
      </ThemeProvider>
  )
}

/* export default function App() {
  return (
    <View style={styles.container}>
      <Text>teste 4 no android studio sucedido!</Text>
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
}); */
export default App;