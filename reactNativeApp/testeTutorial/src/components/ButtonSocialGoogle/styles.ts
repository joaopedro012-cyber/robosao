import styled from "styled-components/native";
import { RectButton } from 'react-native-gesture-handler';
import { RFValue } from 'react-native-responsive-fontsize'

export const Button = styled(RectButton)`
 width: ${RFValue(130)}px;
 height: ${RFValue(130)}px;
 align-items: center;
 flex-direction: row;
 margin-bottom: 16px; 
 border-radius: ${RFValue(5)}px;

`;