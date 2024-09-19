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
      version: 2,  // Atualiza a versão para 2, para incluir a coluna DESCRICAO
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
        ACAO TEXT,
        QTD_SINAIS INTEGER,
        FOREIGN KEY(ID_ROTINA) REFERENCES rotinas(ID_ROTINA)
      )
    ''');
  }

  // Função para atualizar o banco de dados ao mudar a versão
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Adicionar a coluna DESCRICAO na tabela rotinas
      await db.execute('ALTER TABLE rotinas ADD COLUMN DESCRICAO TEXT');
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

  // Função para inserir uma nova ação de execução de rotina (etapa)
  Future<void> insertAcao(int idRotina, String acao, int qtdSinais) async {
    final db = await instance.database;
    await db.insert('ADM_EXECUCAO_ROTINAS', {
      'ID_ROTINA': idRotina,
      'ACAO': acao,
      'QTD_SINAIS': qtdSinais,
    });
  }

  // Função para atualizar uma etapa (ação) existente
  Future<void> updateAcao(int idExecucao, String acao, int qtdSinais) async {
    final db = await instance.database;
    await db.update(
      'ADM_EXECUCAO_ROTINAS',
      {
        'ACAO': acao,
        'QTD_SINAIS': qtdSinais,
      },
      where: 'ID_EXECUCAO = ?',
      whereArgs: [idExecucao],
    );
  }

  // Função para excluir uma ação (etapa) específica de uma rotina
  Future<void> deleteAcao(int idExecucao) async {
    final db = await instance.database;
    await db.delete(
      'ADM_EXECUCAO_ROTINAS',
      where: 'ID_EXECUCAO = ?',
      whereArgs: [idExecucao],
    );
  }

  // Função para excluir uma tabela (caso precise resetar)
  Future<void> excluirTabela(String nomeTabela) async {
    final db = await database;
    await db.execute('DROP TABLE IF EXISTS $nomeTabela');
  }

  // Função para buscar todas as rotinas
  Future<List<Map<String, dynamic>>> getRotinas() async {
    final db = await instance.database;
    return await db.query('rotinas');
  }

  // Função para buscar as execuções de uma rotina específica (etapas)
  Future<List<Map<String, dynamic>>> getExecucoesRotina(int idRotina) async {
    final db = await instance.database;
    return await db.query(
      'ADM_EXECUCAO_ROTINAS',
      where: 'ID_ROTINA = ?',
      whereArgs: [idRotina],
    );
  }
}
