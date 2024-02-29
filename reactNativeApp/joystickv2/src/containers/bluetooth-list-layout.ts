import React from "react";
import {
    View,
    Text,
    FlatList
} from 'react-native'

type Item = {
    name: string;
    key: number;
};

type Props = {
    // Adicione aqui as propriedades que você espera receber
};

function BluetoothListLayout(props: Props){
    const lista: Item[] = [
        {
            name: 'Cristian',
            key: 1
        },
        {
            name: 'Lara',
            key: 2
        }
    ]
    return(
            <FlatList 
                data={lista}
                renderItem={({item}: { item: Item }) => <Text>{item.name}</Text>}
            />
        );
}

export default BluetoothListLayout;
