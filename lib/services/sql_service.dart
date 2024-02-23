import 'package:money_saver/services/constants.dart';
import 'package:sqflite/sqflite.dart';

class SqlService {
  static late Database db;

  Future<Database> open() async {
    db = await openDatabase('money_saver.db', version: 1,
        onCreate: (Database db, int version) async {
      await _createTableCategoryType(db);
      await _createTableAccount(db);
      await _createTableCategory(db);
      await _createTableLogs(db);
    });
    return db;
  }

  Future _createTableCategoryType(Database db) async {
    await db.execute('CREATE TABLE ${Constants.typeCategory} ('
        '${Constants.categoryTypeId}	INTEGER NOT NULL,'
        '${Constants.categoryTypeName}	TEXT NOT NULL,'
        'PRIMARY KEY(${Constants.categoryTypeId} AUTOINCREMENT))');
  }

  Future _createTableAccount(Database db) async {
    await db.execute('''CREATE TABLE ${Constants.account} (
	              ${Constants.accountId} INTEGER NOT NULL,
	              ${Constants.accountName}	TEXT NOT NULL,
	              ${Constants.accountNote}	TEXT,
	              ${Constants.accountMoney}	INTEGER NOT NULL DEFAULT 0,
	              PRIMARY KEY(${Constants.accountId} AUTOINCREMENT))''');
  }

  Future _createTableCategory(Database db) async {
    await db.execute('CREATE TABLE ${Constants.category} ('
        '${Constants.categoryId}	INTEGER,'
        '${Constants.categoryName} TEXT NOT NULL,'
        '${Constants.categoryTypeId}	INTEGER NOT NULL,'
        'PRIMARY KEY(categoryId AUTOINCREMENT))');
  }

  Future _createTableLogs(Database db) async {
    await db.execute('CREATE TABLE ${Constants.logs} ('
        '${Constants.logId}	INTEGER NOT NULL,'
        '${Constants.money}	INTEGER NOT NULL,'
        '${Constants.categoryId}	INTEGER NOT NULL,'
        '${Constants.accountId}	INTEGER NOT NULL,'
        '${Constants.note}	TEXT,'
        '${Constants.dateCreated}	DATETIME NOT NULL,'
        '${Constants.dateModified} DATETIME,'
        ' PRIMARY KEY(${Constants.logId} AUTOINCREMENT));');
  }

  Future close() => db.close();
}
