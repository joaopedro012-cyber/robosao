import { StyleSheet, View, Dimensions } from 'react-native';
import { GestureHandlerRootView } from "react-native-gesture-handler";
import { KorolJoystick } from "korol-joystick";
import Btn_tomada1 from './buttons/tomada1';
import Btn_tomada2 from './buttons/tomada2';
import Btn_tomada3 from './buttons/tomada3';

export default function App() {
    return (
        <View style={styles.container}>
            <GestureHandlerRootView style={{ flex: 1 }}>
                <View style={styles.joystickContainer}>
                    <KorolJoystick color="#06b6d4" radius={75} onMove={(data) => {
                        var posicaoX: number = data.position.x;
                        var posicaoY: number = data.position.y;
                        var forca: number = data.force;
                        var angulo: number = data.angle.degree;


                        if (angulo >= 22.5 && angulo <= 67.51) {

                        }
                        else if (angulo >= 67.5 && angulo <= 112.51) {

                        }

                        else {

                        }
                        console.log(`\n Posição X = ${posicaoX} \n`, `Posição Y = ${posicaoY} \n Força = ${forca}\n Ângulo = ${angulo}`
                            /*
                                337,5 -- 22,5   == D
                                292,5 -- 337,51 == SD
                                247,5 -- 292,51 == S
                                202,5 -- 247,51 == SA
                                157,5 -- 202,51 == A
                                112,5 -- 157,51 == WA
                                67,5  -- 112,51 == W
                                22,5  -- 67,51  == WD 
                        
                                BASE:
                                360 -- D
                                315 -- SD
                                270 -- S
                                225 -- SA
                                180 -- A
                                135 -- WA
                                90  -- W
                                45  -- WD
                        
                        
                            */
                        );
                    }} />
                </View>
                <View style={styles.buttonsContainer}>
                    <Btn_tomada1 />
                    <Btn_tomada2 />
                    <Btn_tomada3 />
                </View>
            </GestureHandlerRootView>
        </View>
    );
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
        flexDirection: 'row',
        justifyContent: 'space-between',
    },
    joystickContainer: {
        flex: 1,
        justifyContent: 'flex-end', // ou 'flex-end' para o canto oposto
        alignItems: 'flex-start', // ou 'flex-end' para o canto oposto
        width: Dimensions.get('window').width * 0.80,
    },
    buttonsContainer: {
        flex: 1,
        justifyContent: 'flex-end', // ou 'flex-start' para o canto oposto
        alignItems: 'flex-end', // ou 'flex-start' para o canto oposto
        width: Dimensions.get('window').width * 0.80,
    },
});
