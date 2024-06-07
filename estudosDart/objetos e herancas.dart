void main() {
  Pessoa pessoa1 = Pessoa('João', 21);
  pessoa1.apresenta();
  Pai pai1 = Pai('José', 35, 'Pedreiro');
  pai1.apresenta();
  Filho filho1 = Filho('José Junior', 12, 'escola infantil');
  filho1.apresenta();
}

class Pessoa {
  String nome='';
  int idade=0;

  Pessoa( this.nome, this.idade );

  void apresenta() {
    print( 'Meu nome é $nome  e minha idade é $idade');
  }
}


class Pai extends Pessoa {
   String profissao='';

  Pai( nome, idade, this.profissao) : super(nome, idade);
  @override
  void apresenta() {
    print('agora puxa a profissão: $profissao , junto da idade e nome do objeto anterior: $nome e $idade');
  }
}

class Filho extends Pessoa {
  String escola = '';
  Filho( nome, idade, this.escola) : super(nome, idade);
  @override
  void apresenta() {
    print('agora puxa a escola: $escola , junto da idade e nome do objeto anterior: $nome e $idade');
  }}
