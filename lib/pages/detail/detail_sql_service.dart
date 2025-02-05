
import 'package:sqflite/sqflite.dart';

import '../../models/log_response_model.dart';
import '../../services/constants.dart';
import '../../services/sql_service.dart';
import '../../utils/date_util.dart';

class DetailSqlService {
  final SqlService _sqlService = SqlService();

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
      }
    }
    db.close();
    return data;
  }
}