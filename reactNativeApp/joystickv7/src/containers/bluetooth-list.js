import React from "react";
import { View, Text, FlatList } from 'react-native'
import Layout from '../components/bluetooth-list-layout'
import Empty from "../components/Empty";
import Toggle from "../components/toggle";
import Subtitle from "../components/subtitle";
//import BluetoothSerial from "react-native-bluetooth-serial-next";
import Device from "../components/device";

function BluetoothList(props){
    const lista = [
        {
            name: 'Cristhian',
            key: '1'
        },
        {
            name: 'Lara',
            key: '2'
        },{
            name: 'Cristhian',
            key: '3'
        },
        {
            name: 'Lara',
            key: '4'
        },
    ]
    const renderEmpty = () => <Empty text='Sem dispositivos disponíveis' />
    const renderItem = ({item}) => {
        return <Device {...item} iconLeft={require('../icones/laptop-fill.svg')} iconRight={require('../icones/gear-fill.svg')}/>

    };

    return(
        <Layout title='Bluetooth'>
            <Toggle/>
            <Subtitle title='Lista de Dispositivos'/>
            <FlatList 
                data={lista}
                ListEmptyComponent={renderEmpty}
                renderItem={renderItem}
            />
        </Layout>
    )
}

export default BluetoothList;