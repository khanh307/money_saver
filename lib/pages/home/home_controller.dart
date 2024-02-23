import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:money_saver/models/account_model.dart';
import 'package:money_saver/models/chart_data.dart';
import 'package:money_saver/models/log_response_model.dart';
import 'package:money_saver/pages/home/home_sql_service.dart';
import 'package:money_saver/utils/dialog_util.dart';
import 'package:money_saver/utils/text_field_format/currency_text_format.dart';
import 'package:money_saver/widgets/input_widget.dart';

class HomeController extends GetxController {
  static HomeController get instants => Get.find();
  final HomeSqlService _sqlService = HomeSqlService();
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();
  RxInt totalThu = 0.obs;
  RxInt totalChi = 0.obs;
  RxInt total = 0.obs;
  RxList<AccountModel> accounts = <AccountModel>[].obs;
  RxList<ChartData> dataThu = <ChartData>[].obs;
  RxList<ChartData> dataChi = <ChartData>[].obs;

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
    await sumTotal();
    await getAccounts();
    await getLogsThu();
    await getLogsChi();
    DialogUtil.hideLoading();
    super.onReady();
  }

  Future reloadData() async {
    total.value = 0;
    totalChi.value = 0;
    totalThu.value = 0;
    await sumTotal();
    await getAccounts();
    await getLogsThu();
    await getLogsChi();
  }

  Future sumTotal() async {
    int resultThu =
        await _sqlService.sum(fromDate: fromDate, toDate: toDate, type: 1);
    totalThu.value = resultThu;
    int resultChi =
        await _sqlService.sum(fromDate: fromDate, toDate: toDate, type: 2);
    totalChi.value = resultChi;
  }

  Future getAccounts() async {
    accounts.clear();
    final data = await _sqlService.getAccounts();
    for (var item in data) {
      total.value += item.accountMoney!;
    }
    accounts.addAll(data);
    total.refresh();
    accounts.refresh();
  }

  Future getLogsThu() async {
    dataThu.clear();
    List<LogsResponseModel> logs =
        await _sqlService.getLogs(fromDate: fromDate, toDate: toDate, type: 1);
    for (var item in logs) {
      dataThu.add(ChartData(
          item.category!.categoryName!, (item.money! / totalThu.value * 100)));
    }
  }

  Future getLogsChi() async {
    dataChi.clear();
    List<LogsResponseModel> logs =
    await _sqlService.getLogs(fromDate: fromDate, toDate: toDate, type: 2);
    for (var item in logs) {
      dataChi.add(ChartData(
          item.category!.categoryName!, double.parse((item.money! / totalChi.value * 100).toStringAsFixed(2))));
    }
  }

  void showDialogNewAccount() async {
    TextEditingController controller = TextEditingController();
    TextEditingController moneyAccountController = TextEditingController(text: '0');
    DialogUtil.showDialog(
        title: 'Thêm tài khoản',
        content: Column(
          children: [
            InputWidget(
              hintText: 'Nhập tên tài khoản',
              controller: controller,
            ),
            const SizedBox(height: 10,),
            InputWidget(
              hintText: 'Nhập tiền trong tài khoản',
              controller: moneyAccountController,
              keyboardType: TextInputType.number,
              inputFormater: [
                FilteringTextInputFormatter.digitsOnly,
                CurrencyTextFormat()
              ],
            ),
          ],
        ),
        actions: [
          ActionDialog(
            text: 'HỦY',
            onPressed: () {
              Get.back();
            },
          ),
          ActionDialog(
            text: 'OK',
            onPressed: () async {
              AccountModel data = AccountModel();
              data.accountName = controller.text;
              data.accountMoney = int.parse(moneyAccountController.text.replaceAll('.', ''));
              int result = await _sqlService.newAccount(data);
              data.accountId = result;
              accounts.add(data);
              Get.back();
            },
          )
        ]);
  }
}
