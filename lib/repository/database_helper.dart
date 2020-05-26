import 'package:school_portal_app/models/aluno_model.dart';
import 'package:school_portal_app/models/atividade_aluno.dart';
import 'package:school_portal_app/models/atividade_model.dart';
import 'package:school_portal_app/models/chamada_model.dart';
import 'package:school_portal_app/models/disciplina_model.dart';
import 'package:school_portal_app/models/disciplina_turma.dart';
import 'package:school_portal_app/models/professor_model.dart';
import 'package:school_portal_app/models/turma_model.dart';


import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  // Instancia do SQFLite Database
  static Database _database;

  // Instancia da classe Helper
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  // Fábrica de construtor
  factory DatabaseHelper() {
    return _instance;
  }

  // Construtor nomeado
  DatabaseHelper._internal();

  // Abre conexão com o banco
  Future<Database> get connection async {
    if (_database == null) {
      _database = await _createDatabase();
    }
    return _database;
  }

  Future<Database> _createDatabase() async {
    String databasesPath = await getDatabasesPath();
    String dbPath = join(databasesPath, 'portal_app.db');

    var database = await openDatabase(
      dbPath,
      version: 4,
      onCreate: _createTables,
    );

    return database;
  }

  void _createTables(Database database, int version) async {
    // Criando a tabela de Cursos

    await database.execute(
      '''
       CREATE TABLE  ProfessorModel(
        rm TEXT PRIMARY KEY ,
        nome TEXT,
        senha TEXT NOT NULL
      );

      CREATE TABLE TurmaModel(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        ano TEXT NOT NULL,
        horario TEXT,
        inicio TEXT,
        termino TEXT
      );
      
      CREATE TABLE AlunoModel(
        rm TEXT PRIMARY KEY ,
        nome TEXT,
        foto TEXT,
        idTurma INTEGER,
        FOREIGN KEY(idTurma) REFERENCES turmaModel(id)
      );

      CREATE TABLE DisciplinaModel (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT,
        rmProfessor TEXT,
        FOREIGN KEY(rmProfessor) REFERENCES ProfessorModel(rm)
      );

      CREATE TABLE DisciplinaTurma(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        idDisciplina INTEGER,
        idTurma INTEGER,
        FOREIGN KEY(idDisciplina) REFERENCES DisciplinaModel(id),
        FOREIGN KEY(idTurma) REFERENCES DisciplinaModel(id)
      );

     CREATE TABLE AtividadeModel(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nota TEXT,
        tipo TEXT,
        dataEntrega TEXT,
        idDisciplina INTEGER,
        FOREIGN KEY(idDisciplina) REFERENCES DisciplinaModel(id)
      );

      CREATE TABLE AtividadeAluno(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        rmAluno TEXT,
        idAtividade INTEGER,
        FOREIGN KEY(rmAluno) REFERENCES AlunoModel(rm),
        FOREIGN KEY(idAtividade) REFERENCES AtividadeModel(id)
      );

      CREATE TABLE ChamadaModel(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        presente INTEGER DEFAULT 0,
        data TEXT,
        rmAluno TEXT,
        idDisciplinaTurma INTEGER,
        FOREIGN KEY(rmAluno) REFERENCES AlunoModel(rm),
        FOREIGN KEY(idDisciplinaTurma) REFERENCES DisciplinaTurma(id)
      );
     
      ''',
    );
    await database.insert("ProfessorModel",
        new ProfessorModel(rm: "123", nome: "Flavio", senha: "123").toMap());
    await database.insert("ProfessorModel",
        new ProfessorModel(rm: "1234", nome: "Pedro", senha: "123").toMap());


    await database.insert("TurmaModel",
        new TurmaModel(id: 11, nome: 'Flutter',ano: '3SIA', horario: 'manha', inicio: '0800',termino: '0945').toMap());
    await database.insert("TurmaModel",
        new TurmaModel(id: 11,nome: 'Flutter',ano: '3SIB',horario: 'manha',inicio: '1000',termino: '1145').toMap());


    await database.insert("AlunoModel",
        new AlunoModel(rm: "85132", nome: "Jean", foto: "foto.png",).toMap());
    await database.insert("AlunoModel",
        new AlunoModel(rm: "80101", nome: "vini", foto: "foto.png",).toMap());
    await database.insert("AlunoModel",
        new AlunoModel(rm: "85183", nome: "petillo", foto: "foto.png",).toMap());
    await database.insert("AlunoModel",
        new AlunoModel(rm: "49845", nome: "vitor", foto: "foto.png",).toMap());

    await database.insert("DisciplinaTurma",
        new DisciplinaTurma(id: 1, idTurma: 1, idDisciplina: 1,).toMap());

    await database.insert("DisciplinaModel",
        new DisciplinaModel(id: 1, nome: "Flavio", rmProfessor: "1",).toMap());

    await database.insert("AtividadeModel",
        new AtividadeModel(id: 1, nota: "10", tipo: "1",dataEntrega: "12/12/2020",idDisciplina: 1).toMap());

    await database.insert("AtividadeAluno",
        new AtividadeAluno(id: 1, rmAluno:  "10", idAtividade: 1).toMap());

    await database.insert("ChamadaModel",
        new ChamadaModel(id: 49845, presente: 0, data:"12/15/2020", rmAluno:"85132", idDisciplinaTurma:1 ).toMap());

      

  }


}
