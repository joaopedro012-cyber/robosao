import React, { useState } from 'react';
import { Button , View , Text } from 'react-native';

export default function Btn_tomada3() {
    const [ativado3, setativado3] = useState<boolean>(false);
    return (
        <View>
            <Text>
                Tomada 3
            </Text>
            <Button 
                title={ativado3 ? "Desativada" : "Ativada"}
                onPress={() => {
                    setativado3(!ativado3);
                    console.log("tomada3" + " " + ativado3)
                }}/>
        </View>
    )
}