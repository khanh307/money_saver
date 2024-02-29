import 'package:money_saver/models/account_model.dart';
import 'package:money_saver/models/category_model.dart';
import 'package:money_saver/models/log_response_model.dart';
import 'package:money_saver/models/logs_model.dart';
import 'package:money_saver/services/constants.dart';
import 'package:money_saver/services/sql_service.dart';
import 'package:sqflite/sqflite.dart';

class EditExpensesSqlService {
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

  Future<AccountModel> getAccountById(int id) async {
    Database db = await _sqlService.open();
    List<Map<String, dynamic>> data = await db.query(Constants.account,
        where: '${Constants.accountId} = ?', whereArgs: [id]);
    db.close();
    return AccountModel.fromMap(data.first);
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

  Future<int> updateAccount(AccountModel data) async {
    Database db = await _sqlService.open();
    final result = await db.update(Constants.account, data.toMap(),
        where: '${Constants.accountId} = ?', whereArgs: [data.accountId]);
    print('data ${data.toMap()}');
    db.close();
    return result;
  }

  Future<List<CategoryModel>> getCategories(int type) async {
    Database db = await _sqlService.open();
    List<Map<String, dynamic>> data = await db.query(Constants.category,
        where: '${Constants.categoryTypeId} = ?', whereArgs: [type]);
    List<CategoryModel> result = [];
    if (data.isNotEmpty) {
      for (var item in data) {
        result.add(CategoryModel.fromMap(item));
      }
    }
    db.close();
    return result;
  }

  Future<int> newCategory(CategoryModel data) async {
    Database db = await _sqlService.open();
    int newId = await db.insert(Constants.category, data.toMap());
    db.close();
    return newId;
  }

  Future<int> deleteCategory(CategoryModel data) async {
    Database db = await _sqlService.open();
    final list = await db.query(Constants.logs,
        where: '${Constants.categoryId} = ?', whereArgs: [data.categoryId]);
    if (list.isNotEmpty) {
      return -1;
    }
    int status = await db.delete(Constants.category,
        where: '${Constants.categoryId} = ?', whereArgs: [data.categoryId]);
    db.close();
    return status;
  }

  Future<int> updateCategory(CategoryModel data) async {
    Database db = await _sqlService.open();
    final result = await db.update(Constants.category, data.toMap(),
        where: '${Constants.categoryId} = ?', whereArgs: [data.categoryId]);
    db.close();
    return result;
  }

  Future<int> updateLogs(
      LogsModel data, CategoryModel category, LogsResponseModel oldData) async {
    Database db = await _sqlService.open();
    int newId = await db.update(Constants.logs, data.toMap(),
        where: '${Constants.logId} = ?', whereArgs: [data.logId]);
    db.close();
    AccountModel account = await getAccountById(data.accountId!);
    int total = account.accountMoney!; // -10
    if (category.categoryTypeId == 1) {
      total += data.money!;
    } else {
      total -= data.money!; // -10-10 = -20;
    }
    account.accountMoney = total;
    if (newId > 0) {
      updateAccount(account);
    }
    AccountModel oldAccount = await getAccountById(oldData.account!.accountId!);
    int totalOld = oldAccount.accountMoney!;
    if (oldData.category!.categoryTypeId == 1) {
      totalOld -= oldData.money!;
    } else {
      totalOld += oldData.money!;
    }
    oldData.account!.accountMoney = totalOld;
    if (newId > 0) {
      updateAccount(oldData.account!);
    }
    return newId;
  }

  Future<int> deleteLogs(LogsResponseModel model) async {
    Database db = await _sqlService.open();
    int status = await db.delete(Constants.logs,
        where: '${Constants.logId} = ?', whereArgs: [model.logId]);
    db.close();
    AccountModel accountModel = await getAccountById(model.account!.accountId!);
    int total = accountModel.accountMoney!;
    if (model.category!.categoryTypeId == 1) {
      total -= model.money!;
    } else {
      total += model.money!;
    }
    accountModel.accountMoney = total;
    if (status > 0) {
      updateAccount(accountModel);
    }
    return status;
  }
}
