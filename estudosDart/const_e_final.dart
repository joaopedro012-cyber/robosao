void main() {

//  Personagem personagem1 = new Personagem(12, 13, 'Teste');
  Jogador jogador1 = new Jogador(10, 11, 'hero1');
  Inimigo inimigo1 = new Inimigo(12, 13, 'vilao1');
  jogador1.mostraPersonagem();
  inimigo1.mostraPersonagem();
  
}

abstract class Personagem {
  int posicaoX = 0;
  int posicaoY = 0;
  String nome;
  
  Personagem( this.posicaoY, this.posicaoX, this.nome);
  void mostraPersonagem() {
    print('$posicaoX, $posicaoY, $nome');
  }
}

class Jogador extends Personagem { Jogador(int posicaoX, int posicaoY, String nome) : super ( posicaoX, posicaoY, nome);
}

class Inimigo extends Personagem {
  Inimigo( int posicaoX, int  posicaoY, String nome) : super( posicaoX, posicaoY, nome );
}
