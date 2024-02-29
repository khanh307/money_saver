import 'package:get/get.dart';
import 'package:money_saver/pages/bottom_nav/bottom_nav_controller.dart';
import 'package:money_saver/pages/edit_expenses/edit_expenses_controller.dart';
import 'package:money_saver/pages/home/home_controller.dart';
import 'package:money_saver/pages/logs_page/logs_controller.dart';
import 'package:money_saver/pages/new_expenses/new_expenses_controller.dart';
import 'package:money_saver/pages/transfer/transfer_controller.dart';

class AllBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BottomNavController());
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => NewExpensesController());
    Get.lazyPut(() => LogsController());
    Get.lazyPut(() => EditExpensesController());
    Get.lazyPut(() => TransferController());
  }
}
