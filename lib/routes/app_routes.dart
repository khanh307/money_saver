import 'package:get/get.dart';
import 'package:money_saver/bindings/all_bindings.dart';
import 'package:money_saver/pages/bottom_nav/bottom_nav_page.dart';
import 'package:money_saver/pages/edit_expenses/edit_expenses_page.dart';
import 'package:money_saver/pages/home/home_page.dart';
import 'package:money_saver/pages/logs_page/logs_page.dart';
import 'package:money_saver/pages/new_expenses/new_expenses_page.dart';
import 'package:money_saver/pages/transfer/transfer_page.dart';

class AppRoutes {
  static const String initialRoute = '/';
  static final pages = [
    GetPage(
        name: '/',
        page: () => const BottomNavPage(),
        binding: AllBindings()),
    GetPage(
        name: '/home',
        page: () => const HomePage(),
        transition: Transition.rightToLeft,
        binding: AllBindings()),
    GetPage(
        name: '/newExpenses',
        page: () => const NewExpensesPage(),
        transition: Transition.rightToLeft,
        binding: AllBindings()),
    GetPage(
        name: '/logs',
        page: () => const LogsPage(),
        transition: Transition.rightToLeft,
        binding: AllBindings()),
    GetPage(
        name: EditExpensesPage.routeName,
        page: () => const EditExpensesPage(),
        transition: Transition.rightToLeft,
        binding: AllBindings()),
    GetPage(
        name: '/transfer',
        page: () => const TransferPage(),
        transition: Transition.rightToLeft,
        binding: AllBindings()),
  ];
}
