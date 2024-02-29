import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:money_saver/pages/home/home_page.dart';
import 'package:money_saver/pages/logs_page/logs_controller.dart';
import 'package:money_saver/pages/logs_page/logs_page.dart';
import 'package:money_saver/pages/new_expenses/new_expenses_controller.dart';
import 'package:money_saver/pages/new_expenses/new_expenses_page.dart';
import 'package:money_saver/pages/transfer/transfer_controller.dart';
import 'package:money_saver/pages/transfer/transfer_page.dart';

class BottomNavController extends GetxController {
  RxInt currentPage = 0.obs;
  List<Widget> pages = const [
    HomePage(),
    NewExpensesPage(),
    LogsPage(),
    TransferPage()
  ];
  bool isFirst2 = true;
  bool isFirst1 = true;
  bool isFirst3 = true;

  void changePage(int value) async {
    currentPage.value = value;

    if (value == 1 && !isFirst1) {
      await NewExpensesController.instants.reloadData();
    }
    if (value == 1) {
      isFirst1 = false;
    }

    if (value == 2 && !isFirst2) {
      await LogsController.instants.reloadData();
    }
    if (value == 2) {
      isFirst2 = false;
    }

    if (value == 3 && !isFirst3) {
      await TransferController.instants.getAccounts();
    }

    if (value == 3) {
      isFirst3 = false;
    }
  }
}
