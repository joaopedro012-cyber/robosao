import React, { useState } from 'react';
import { Button , View , Text } from 'react-native';

export default function Btn_tomada1() {
    const [ativado1, setAtivado] = useState<boolean>(false);
    return (
        <View>
            <Text>
                Tomada 1
            </Text>
            <Button 
                title={ativado1 ? "Desativada" : "Ativada"}
                onPress={() => {
                    setAtivado(!ativado1);
                    console.log("tomada1" + " " + ativado1)
                }}/>
        </View>
    )
}