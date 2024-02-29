import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_saver/pages/bottom_nav/bottom_nav_controller.dart';
import 'package:money_saver/pages/home/home_page.dart';
import 'package:money_saver/pages/logs_page/logs_page.dart';
import 'package:money_saver/pages/new_expenses/new_expenses_page.dart';
import 'package:money_saver/utils/const/app_colors.dart';

class BottomNavPage extends GetView<BottomNavController> {
  const BottomNavPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => controller.pages[controller.currentPage.value]),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
            currentIndex: controller.currentPage.value,
            selectedItemColor: AppColors.primaryColor,
            unselectedItemColor: AppColors.textColor,
            showUnselectedLabels: true,
            onTap: (value) {
              controller.changePage(value);
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Tổng quan',
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.add_box_rounded), label: 'Thêm mới'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.account_balance_wallet), label: 'Nhật ký'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.local_atm), label: 'Chuyển tiền'),
            ],
          )), // Choose the nav bar style with this property.
    );
  }
}
