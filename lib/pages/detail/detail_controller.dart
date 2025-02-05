import 'dart:convert';

import 'package:get/get.dart';
import 'package:money_saver/models/category_model.dart';
import 'package:money_saver/models/log_response_model.dart';
import 'package:money_saver/pages/detail/detail_sql_service.dart';

import '../../utils/dialog_util.dart';

class DetailController extends GetxController {
  final DetailSqlService _sqlService = DetailSqlService();
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();
  Rx<Map<CategoryModel, List<LogsResponseModel>>> mapLogs = Rx({});

  @override
  void onInit() {
    DateTime dateNow = DateTime.now();
    fromDate = DateTime(dateNow.year, dateNow.month, 1);
    toDate = DateTime(dateNow.year, dateNow.month + 1, 0);
    super.onInit();
  }

  @override
  void onReady() async {
    await DialogUtil.showLoading();
    await getLogs();
    DialogUtil.hideLoading();
    super.onReady();
  }

  Future getLogs() async {
    mapLogs.value.clear();
    final result = await _sqlService.getLogs(
        fromDate: fromDate,
        toDate: toDate,
    );

    for (var item in result) {
      CategoryModel key = item.category!;
      if (!mapLogs.value.containsKey(key)) {
        mapLogs.value[key] = <LogsResponseModel>[];
      }
      mapLogs.value[key]!.add(item);
    }
    mapLogs.refresh();
  }
}
