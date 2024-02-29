
import 'package:money_saver/models/account_model.dart';
import 'package:money_saver/services/constants.dart';
import 'package:money_saver/services/sql_service.dart';
import 'package:sqflite/sqflite.dart';

class TransferSqlService {
  final SqlService _sqlService = SqlService();

  Future<List<AccountModel>> getAccounts() async {
    Database db = await _sqlService.open();
    List<Map<String, dynamic>> data = await db.query(Constants.account);
    List<AccountModel> result = [];
    if (data.isNotEmpty) {
      for (var item in data) {
        result.add(AccountModel.fromMap(item));
      }
    }
    db.close();
    return result;
  }

  Future<int> newAccount(AccountModel data) async {
    Database db = await _sqlService.open();
    int newId = await db.insert(Constants.account, data.toMap());
    db.close();
    return newId;
  }

  Future<int> deleteAccount(AccountModel data) async {
    Database db = await _sqlService.open();
    final list = await db.query(Constants.logs,
        where: '${Constants.accountId} = ?', whereArgs: [data.accountId]);
    if (list.isNotEmpty) {
      return -1;
    }
    int status = await db.delete(Constants.account,
        where: '${Constants.accountId} = ?', whereArgs: [data.accountId]);
    db.close();
    return status;
  }

  Future<AccountModel> getAccountById(int id) async {
    Database db = await _sqlService.open();
    List<Map<String, dynamic>> data = await db.query(Constants.account,
        where: '${Constants.accountId} = ?', whereArgs: [id]);
    db.close();
    return AccountModel.fromMap(data.first);
  }

  Future<int> updateAccount(AccountModel data) async {
    Database db = await _sqlService.open();
    final result = await db.update(Constants.account, data.toMap(),
        where: '${Constants.accountId} = ?', whereArgs: [data.accountId]);
    print('data ${data.toMap()}');
    db.close();
    return result;
  }

  Future<bool> transfer(AccountModel fromAccount, AccountModel toAccount, int money) async {
    fromAccount = await getAccountById(fromAccount.accountId!);
    toAccount = await getAccountById(toAccount.accountId!);
    fromAccount.accountMoney = fromAccount.accountMoney! - money;
    toAccount.accountMoney = toAccount.accountMoney! + money;
    int status = await updateAccount(fromAccount);
    if (status < 0) return false;
    status = await updateAccount(toAccount);
    if (status < 0) return false;
    return true;
  }
}