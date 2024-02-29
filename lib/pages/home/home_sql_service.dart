import 'package:money_saver/models/account_model.dart';
import 'package:money_saver/models/log_response_model.dart';
import 'package:money_saver/services/constants.dart';
import 'package:money_saver/services/sql_service.dart';
import 'package:money_saver/utils/date_util.dart';
import 'package:sqflite/sqflite.dart';

class HomeSqlService {
  final SqlService _sqlService = SqlService();

  Future<String> getPathDB() async {
    Database db = await _sqlService.open();
    String path = db.path;
    db.close();
    return path;
  }

  Future<int> sum(
      {required DateTime fromDate,
      required DateTime toDate,
      required int type}) async {
    Database db = await _sqlService.open();
    String sql =
        'select sum(${Constants.money}) as total from ${Constants.logs}, ${Constants.category}'
        ' where ${Constants.logs}.${Constants.categoryId} = ${Constants.category}.${Constants.categoryId}'
        ' and ${Constants.category}.${Constants.categoryTypeId} = $type'
        ' and ${Constants.dateCreated} <= \'${DateUtil.formatDateYYYYMMdd(toDate)}\''
        ' and ${Constants.dateCreated} >= \'${DateUtil.formatDateYYYYMMdd(fromDate)}\'';
    List<Map<String, dynamic>> result = await db.rawQuery(sql);
    db.close();
    if (result.isEmpty || result.first['total'] == null) return 0;
    return result.first['total'];
  }

  Future<int> newAccount(AccountModel data) async {
    Database db = await _sqlService.open();
    int newId = await db.insert(Constants.account, data.toMap());
    db.close();
    return newId;
  }

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

  Future<List<LogsResponseModel>> getLogs(
      {required DateTime fromDate,
      required DateTime toDate,
      required int type}) async {
    Database db = await _sqlService.open();
    String sql = 'select ${Constants.logId}, sum(${Constants.money}) as ${Constants.money}, '
        '${Constants.category}.${Constants.categoryId}, ${Constants.categoryTypeId},'
        '${Constants.category}.${Constants.categoryName},'
        ' ${Constants.note}, ${Constants.dateCreated}, ${Constants.dateModified},'
        ' ${Constants.account}.${Constants.accountId}, ${Constants.account}.${Constants.accountName}'
        ' from ${Constants.logs}, ${Constants.category}, ${Constants.account}'
        ' where ${Constants.logs}.${Constants.categoryId} = ${Constants.category}.${Constants.categoryId}'
        ' and ${Constants.logs}.${Constants.accountId} = ${Constants.account}.${Constants.accountId}'
        ' and ${Constants.category}.${Constants.categoryTypeId} = $type'
        ' and ${Constants.dateCreated} <= \'${DateUtil.formatDateYYYYMMdd(toDate)}\''
        ' and ${Constants.dateCreated} >= \'${DateUtil.formatDateYYYYMMdd(fromDate)}\''
        ' group by ${Constants.logs}.${Constants.categoryId}'
        ' order by ${Constants.dateCreated} DESC ';
    final result = await db.rawQuery(sql);
    List<LogsResponseModel> data = [];
    if (result.isNotEmpty) {
      for (var item in result) {
        data.add(LogsResponseModel.fromMap(item));
        print('item $item');
      }
    }
    db.close();
    return data;
  }
}
