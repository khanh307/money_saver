import 'dart:math';

import 'package:get/get.dart';
import 'package:money_saver/models/log_response_model.dart';
import 'package:money_saver/pages/logs_page/logs_sql_service.dart';
import 'package:money_saver/utils/date_util.dart';
import 'package:money_saver/utils/dialog_util.dart';

class LogsController extends GetxController {
  static LogsController get instants => Get.find();
  Rx<DateTime> dateNow = Rx(DateTime.now());
  final LogsSqlService _sqlService = LogsSqlService();
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();
  RxInt totalThu = 0.obs;
  RxInt totalChi = 0.obs;
  RxInt total = 0.obs;
  RxList<LogsResponseModel> logs = <LogsResponseModel>[].obs;
  Rx<Map<String, List<LogsResponseModel>>> mapLogs = Rx({});

  @override
  void onReady() async {
    await DialogUtil.showLoading();
    await sumTotal();
    await getLogs();
    DialogUtil.hideLoading();
    super.onReady();
  }

  Future reloadData() async {
    totalThu.value = 0;
    totalChi.value = 0;
    total.value = 0;
    await sumTotal();
    await getLogs();
    refresh();
  }

  void getDayOfMonth() async {
    fromDate = DateTime(dateNow.value.year, dateNow.value.month, 1);
    toDate = DateTime(dateNow.value.year, dateNow.value.month + 1, 0);
  }

  Future sumTotal() async {
    getDayOfMonth();
    int resultThu =
        await _sqlService.sum(fromDate: fromDate, toDate: toDate, type: 1);
    totalThu.value = resultThu;
    int resultChi =
        await _sqlService.sum(fromDate: fromDate, toDate: toDate, type: 2);
    totalChi.value = resultChi;
    total.value = totalThu.value - totalChi.value;
  }

  Future getLogs() async {
    logs.clear();
    mapLogs.value.clear();
    final result = await _sqlService.getLogs(fromDate: fromDate, toDate: toDate);
    logs.addAll(result);
    for (var item in logs) {
      String key = DateUtil.formatDateYYYYMMdd(item.dateCreated!);
      if (!mapLogs.value.containsKey(key)) {
        mapLogs.value[key] = <LogsResponseModel>[];
      }
      mapLogs.value[key]!.add(item);
    }
    mapLogs.refresh();
  }

}
