import React from 'react';

const Header: React.FC = () => {
    return(
        <header>
            <h1>
                Cabeçalho do Site
            </h1>
            <nav>
                <ul><a href="">Inicio</a></ul>
                <ul><a href="">Sobre nós</a></ul>
                <ul><a href="">Novo</a></ul>
            </nav>
        </header>
    )
 }

export default Header;