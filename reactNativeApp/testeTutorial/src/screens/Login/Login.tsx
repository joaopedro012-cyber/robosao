import React from 'react';
import { SafeAreaView, Text } from 'react-native';
import { Container, ContentHeader, Title, Description, ViewButton, ContentBody, ContentFooter } from './styles';
import { ButtonSocialGoogle } from "../../components/ButtonSocialGoogle/ButtonSocialGoogle";
const Login: React.FC = () => {
    return (
        <SafeAreaView>
        <Container>
            <ContentHeader>
                <Title><Text>Screen Login teste typescript curso</Text></Title>
                <Description>
                    Teste
                </Description>
                <ViewButton><ButtonSocialGoogle /></ViewButton>
            </ContentHeader>
            <ContentBody>

            </ContentBody>
            <ContentFooter>

            </ContentFooter>
        </Container>
        </SafeAreaView>
    );
};


/* const Login2: React.FC = () => {
    return (
        <Container>
            <Text>Screen Login</Text>
        </Container>
    );
}; */

export { Login /* , Login2 */ };