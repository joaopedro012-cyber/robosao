import React, { useState } from 'react';
import { Button , View , Text } from 'react-native';

export default function Btn_tomada2() {
    const [ativado2, setativado2] = useState<boolean>(false);
    return (
        <View>
            <Text>
                Tomada 2
            </Text>
            <Button 
                title={ativado2 ? "Desativada" : "Ativada"}
                onPress={() => {
                    setativado2(!ativado2);
                    console.log("tomada2" + " " + ativado2)
                }}/>
        </View>
    )
}