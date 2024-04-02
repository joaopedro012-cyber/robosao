import React from "react";
import{
    View,
    Text,
    StyleSheet   
} from 'react-native'

function Empty(props){
    return(
        <View>
            <Text style={styles.text}>
                {props.text}
            </Text>
        </View>
    )
}

const styles = StyleSheet.create({
    fontSize:20
})
export default Empty;