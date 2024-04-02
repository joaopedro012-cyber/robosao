import React from "react";
import {
    View,
    Text,
    Switch,
    StyleSheet
} from 'react-native'

function Toggle(props){
    return(
        <View style={styles.container}>
            <Text style={styles.text}>ON</Text>
            <Switch style={styles.switch} value={props.value} onValueChange={props.onValueChange}></Switch>
        </View>
    )
}

const styles= StyleSheet.create(
    {
     container:{
        paddingVertical:15,
        flexDirection: 'row'
     },   
     text:{
        fontWeight:'bold',
        fontSize: 20,
        flex:1
     },
     switch:{
        width: 50,
        
     },
    }
)
export default Toggle