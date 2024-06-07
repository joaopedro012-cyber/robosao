void main() {
//  Mundo meuMundo = new Mundo();
 // meuMundo.gravidade = 10;
//  print(meuMundo.gravidade);
  print(Mundo.gravidade);
  Mundo.gravidade = 20;
  print( Mundo.gravidade );
}

class Mundo{
  static double gravidade = 9.81;

  Mundo();
}
