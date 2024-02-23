import styled from 'styled-components/native';
import { RFValue } from 'react-native-responsive-fontsize'; 
import { theme } from '../../styles/theme';

export const Container = styled.View`
    padding: ${RFValue(20)}px;
`;

export const ContentHeader = styled.View`
    padding: ${RFValue(20)}px;
    background-color: tomato;
    align-items: center;
    justify-content: center;
`;
export const ContentBody = styled.View``
export const ContentFooter = styled.View``
export const Title = styled.Text`
    text-align: center;
    font-size: ${RFValue(22
    )};
`;
export const Description = styled.Text`
    margin-top: ${RFValue(60)}px;
    font-size: ${RFValue(15)}px;
    font-family: ${({ theme }) => theme.FONTS.POPPINSLIGHT
};
`;
export const ViewButton = styled.View`
`
