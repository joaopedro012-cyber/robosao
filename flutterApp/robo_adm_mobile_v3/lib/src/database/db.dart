import 'package:sqflite/sqflite.dart';  
import 'package:path/path.dart';

class DB {
  // Construtor privado para Singleton
  DB._();
  static final DB instance = DB._();

  static Database? _database;

  // Acesso ao banco de dados
  Future<Database> get database async {
    if (_database != null) return _database!;
    return await _initDatabase();
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'AplicativoRobo.db');
    return await openDatabase(
      path,
      version: 2, // Atualiza a versão para 2
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  // Função para criar o banco de dados na primeira vez
  Future<void> _onCreate(Database db, int version) async {
    await db.execute(''' 
      CREATE TABLE rotinas (
        ID_ROTINA INTEGER PRIMARY KEY AUTOINCREMENT,
        NOME TEXT,
        DESCRICAO TEXT
      )
    ''');

    await db.execute(''' 
      CREATE TABLE ADM_EXECUCAO_ROTINAS (
        ID_EXECUCAO INTEGER PRIMARY KEY AUTOINCREMENT,
        ID_ROTINA INTEGER,
        ACAO_HORIZONTAL TEXT,
        QTD_HORIZONTAL INTEGER,
        ACAO_VERTICAL TEXT,
        QTD_VERTICAL INTEGER,
        ACAO_PLATAFORMA TEXT,
        QTD_PLATAFORMA INTEGER,
        ACAO_BOTAO1 TEXT,
        QTD_BOTAO1 INTEGER,
        ACAO_BOTAO2 TEXT,
        QTD_BOTAO2 INTEGER,
        ACAO_BOTAO3 TEXT,
        QTD_BOTAO3 INTEGER,
        DT_EXECUCAO_UNIX_MICROSSEGUNDOS INTEGER,
        DT_EXCLUSAO_UNIX_MICROSSEGUNDOS INTEGER,
        FOREIGN KEY(ID_ROTINA) REFERENCES rotinas(ID_ROTINA)
      )
    ''');
  }

  // Função para atualizar o banco de dados ao mudar a versão
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Adiciona a coluna ACAO_HORIZONTAL se não existir
      await db.execute('ALTER TABLE ADM_EXECUCAO_ROTINAS ADD COLUMN ACAO_HORIZONTAL TEXT');
    }
  }

  // Função para inserir uma nova rotina
  Future<void> insertRotina(String nome, String descricao) async {
    final db = await instance.database;
    await db.insert('rotinas', {
      'NOME': nome,
      'DESCRICAO': descricao,
    });
  }

  // Função para atualizar uma rotina existente
  Future<void> updateRotina(int idRotina, String nome, String descricao) async {
    final db = await instance.database;
    await db.update(
      'rotinas',
      {'NOME': nome, 'DESCRICAO': descricao},
      where: 'ID_ROTINA = ?',
      whereArgs: [idRotina],
    );
  }

  // Função para excluir uma rotina e suas execuções associadas
  Future<void> deleteRotina(int idRotina) async {
    if (idRotina <= 0) {
      throw Exception("ID da rotina deve ser maior que zero.");
    }

    final db = await instance.database;
    await db.transaction((txn) async {
      // Primeiro, exclua todas as execuções associadas à rotina
      await txn.delete(
        'ADM_EXECUCAO_ROTINAS',
        where: 'ID_ROTINA = ?',
        whereArgs: [idRotina],
      );
      // Agora, exclua a rotina em si
      await txn.delete(
        'rotinas',
        where: 'ID_ROTINA = ?',
        whereArgs: [idRotina],
      );
    });
  }

  // Função para inserir uma nova execução de rotina
  Future<void> insertExecucaoRotina({
    required int idRotina,
    required String acaoHorizontal,
    required int qtdHorizontal,
    required String acaoVertical,
    required int qtdVertical,
    required String acaoPlataforma,
    required int qtdPlataforma,
    required String acaoBotao1,
    required int qtdBotao1,
    required String acaoBotao2,
    required int qtdBotao2,
    required String acaoBotao3,
    required int qtdBotao3,
    required int dtExecucao,
    int? dtExclusao,
  }) async {
    final db = await instance.database;
    await db.insert('ADM_EXECUCAO_ROTINAS', {
      'ID_ROTINA': idRotina,
      'ACAO_HORIZONTAL': acaoHorizontal,
      'QTD_HORIZONTAL': qtdHorizontal,
      'ACAO_VERTICAL': acaoVertical,
      'QTD_VERTICAL': qtdVertical,
      'ACAO_PLATAFORMA': acaoPlataforma,
      'QTD_PLATAFORMA': qtdPlataforma,
      'ACAO_BOTAO1': acaoBotao1,
      'QTD_BOTAO1': qtdBotao1,
      'ACAO_BOTAO2': acaoBotao2,
      'QTD_BOTAO2': qtdBotao2,
      'ACAO_BOTAO3': acaoBotao3,
      'QTD_BOTAO3': qtdBotao3,
      'DT_EXECUCAO_UNIX_MICROSSEGUNDOS': dtExecucao,
      'DT_EXCLUSAO_UNIX_MICROSSEGUNDOS': dtExclusao ?? 0,
    });
  }

  // Função para atualizar uma execução de rotina
  Future<void> updateExecucaoRotina(int idExecucao, {
    required String acaoHorizontal,
    required int qtdHorizontal,
    required String acaoVertical,
    required int qtdVertical,
    required String acaoPlataforma,
    required int qtdPlataforma,
    required String acaoBotao1,
    required int qtdBotao1,
    required String acaoBotao2,
    required int qtdBotao2,
    required String acaoBotao3,
    required int qtdBotao3,
  }) async {
    final db = await instance.database;
    await db.update(
      'ADM_EXECUCAO_ROTINAS',
      {
        'ACAO_HORIZONTAL': acaoHorizontal,
        'QTD_HORIZONTAL': qtdHorizontal,
        'ACAO_VERTICAL': acaoVertical,
        'QTD_VERTICAL': qtdVertical,
        'ACAO_PLATAFORMA': acaoPlataforma,
        'QTD_PLATAFORMA': qtdPlataforma,
        'ACAO_BOTAO1': acaoBotao1,
        'QTD_BOTAO1': qtdBotao1,
        'ACAO_BOTAO2': acaoBotao2,
        'QTD_BOTAO2': qtdBotao2,
        'ACAO_BOTAO3': acaoBotao3,
        'QTD_BOTAO3': qtdBotao3,
      },
      where: 'ID_EXECUCAO = ?',
      whereArgs: [idExecucao],
    );
  }

  // Função para excluir uma execução de rotina
  Future<void> deleteExecucao(int idExecucao) async {
    final db = await instance.database;
    await db.delete(
      'ADM_EXECUCAO_ROTINAS',
      where: 'ID_EXECUCAO = ?',
      whereArgs: [idExecucao],
    );
  }

  // Função para excluir uma ação de rotina
  Future<void> deleteAcao(int idAcao) async {
    final db = await instance.database;
    await db.delete(
      'ADM_EXECUCAO_ROTINAS',
      where: 'ID_EXECUCAO = ?',
      whereArgs: [idAcao],
    );
  }

  // Função para buscar todas as rotinas
  Future<List<Map<String, dynamic>>> getRotinas() async {
    final db = await instance.database;
    return await db.query('rotinas');
  }

  // Função para buscar as execuções de uma rotina específica
  Future<List<Map<String, dynamic>>> getExecucoesRotina(int idRotina) async {
    final db = await instance.database;
    return await db.query(
      'ADM_EXECUCAO_ROTINAS',
      where: 'ID_ROTINA = ?',
      whereArgs: [idRotina],
    );
  }

  // Função para inserir uma nova ação
  Future<void> insertAcao({
    required int idRotina,
    required String acaoHorizontal,
    required String acaoVertical,
    required String acaoPlataforma,
    required String acaoBotao1,
    required String acaoBotao2,
    required String acaoBotao3,
    required int qtdHorizontal,
    required int qtdVertical,
    required int qtdPlataforma,
    required int qtdBotao1,
    required int qtdBotao2,
    required int qtdBotao3,
    required int dtExecucao,
  }) async {
    final db = await instance.database;
    await db.insert(
      'ADM_EXECUCAO_ROTINAS', // Tabela onde as ações são armazenadas
      {
        'ID_ROTINA': idRotina,
        'ACAO_HORIZONTAL': acaoHorizontal,
        'QTD_HORIZONTAL': qtdHorizontal,
        'ACAO_VERTICAL': acaoVertical,
        'QTD_VERTICAL': qtdVertical,
        'ACAO_PLATAFORMA': acaoPlataforma,
        'QTD_PLATAFORMA': qtdPlataforma,
        'ACAO_BOTAO1': acaoBotao1,
        'QTD_BOTAO1': qtdBotao1,
        'ACAO_BOTAO2': acaoBotao2,
        'QTD_BOTAO2': qtdBotao2,
        'ACAO_BOTAO3': acaoBotao3,
        'QTD_BOTAO3': qtdBotao3,
        'DT_EXECUCAO_UNIX_MICROSSEGUNDOS': dtExecucao,
      },
    );
  }
}
