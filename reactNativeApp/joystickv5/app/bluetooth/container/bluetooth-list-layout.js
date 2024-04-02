import react from "react";
import { View, Text, FlatList} from "react-native";

function BluetoothListLayout(props){
    const lista = [
            {
                name: 'Cristhian',
                key:'1'
            },
            {
                name: 'Lara',
                key:'2'
            },
            {
                name: 'Cristhian',
                key:'3'
            }
    ]

    return(
        <FlatList data={lista} renderItem={({item}) => <Text>{item.name}</Text>} />
    );
}