import React from 'react'
import {
    View,
    Text,
    Switch,
    StyleSheet
} from 'react-native'

function Subtitle(props){
    return(
        <View style={styles.container}>
            <Text style={styles.title}>{props.title}</Text>
            <View style={styles.line}/>
        </View>
    )
}

const styles = StyleSheet.create({
    container:{
        flexDirection:'row',
        marginVertical:15,
        alignItems:'center'
    },
    title:{
        fontSize:18,
        fontWeight:'bold',
        color:'grey'
    },
    line:{
        borderBottomWidth:1,
        marginLeft:5,
        flex:1,
        marginTop:3,
        borderColor:'#eceff'
    }
})

export default Subtitle;