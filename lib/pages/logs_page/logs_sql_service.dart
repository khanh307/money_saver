import 'package:money_saver/models/log_response_model.dart';
import 'package:money_saver/services/constants.dart';
import 'package:money_saver/services/sql_service.dart';
import 'package:money_saver/utils/date_util.dart';
import 'package:sqflite/sqflite.dart';

class LogsSqlService {
  final SqlService _sqlService = SqlService();

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

  Future<List<LogsResponseModel>> getLogs(
      {required DateTime fromDate, required DateTime toDate}) async {
    Database db = await _sqlService.open();
    String sql = 'select ${Constants.logId}, ${Constants.money}, '
        '${Constants.category}.${Constants.categoryId}, ${Constants.categoryTypeId},'
        '${Constants.category}.${Constants.categoryName},'
        ' ${Constants.note}, ${Constants.dateCreated}, ${Constants.dateModified},'
        ' ${Constants.account}.${Constants.accountId}, ${Constants.account}.${Constants.accountName}'
        ' from ${Constants.logs}, ${Constants.category}, ${Constants.account}'
        ' where ${Constants.logs}.${Constants.categoryId} = ${Constants.category}.${Constants.categoryId}'
        ' and ${Constants.logs}.${Constants.accountId} = ${Constants.account}.${Constants.accountId}'
        ' and ${Constants.dateCreated} <= \'${DateUtil.formatDateYYYYMMdd(toDate)}\''
        ' and ${Constants.dateCreated} >= \'${DateUtil.formatDateYYYYMMdd(fromDate)}\''
        ' order by ${Constants.dateCreated} DESC ';
    print('sql $sql');
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
