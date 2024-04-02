import React from "react";
import{
    View,
    Text,
    TouchableOpacity,
    StyleSheet,
    Image
} from 'react-native'

function Device(props){
    return(
        <TouchableOpacity style={styles.wrapper} onPress={props.onPress}>
            <View style={styles.wrapperLeft}>
                <Image style={styles.wrapperLeft} source={props.iconLeft}/>
            </View>
            <View style={styles.wrapperName}>
                <Text style={styles.name}>
                    {props.name}
                </Text>
            </View>
            <Image style={styles.iconRight} source={props.iconRight}/>
        </TouchableOpacity>
    )
}

const styles = StyleSheet.create({
    wrapper:{

    },
    wrapperLeft:{

    },
    wrapperName:{
        
    }
})

export default Device;