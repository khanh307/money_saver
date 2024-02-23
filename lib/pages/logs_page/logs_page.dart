import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_saver/models/log_response_model.dart';
import 'package:money_saver/pages/edit_expenses/edit_expenses_page.dart';
import 'package:money_saver/pages/logs_page/logs_controller.dart';
import 'package:money_saver/utils/const/app_colors.dart';
import 'package:money_saver/utils/number_utils.dart';
import 'package:money_saver/widgets/empty_data.dart';
import 'package:money_saver/widgets/expend_widget.dart';
import 'package:money_saver/widgets/month_dialog_picker.dart';
import 'package:money_saver/widgets/text_widget.dart';

class LogsPage extends GetView<LogsController> {
  const LogsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nhật ký'),
        actions: [
          GestureDetector(
            onTap: () {
              MonthDialogPicker.showDialogPicker(context,
                  year: controller.dateNow.value.year,
                  month: controller.dateNow.value.month,
                  onChange: (int value) async {
                controller.dateNow.value =
                    controller.dateNow.value.copyWith(month: value);
                await controller.sumTotal();
                await controller.getLogs();
              }, onChangeYear: (int value) async {
                controller.dateNow.value =
                    controller.dateNow.value.copyWith(year: value);
                await controller.sumTotal();
                await controller.getLogs();
              });
            },
            child: Row(
              children: [
                Obx(() => TextWidget(
                    text:
                        'Th${controller.dateNow.value.month} ${controller.dateNow.value.year}')),
                const Icon(Icons.arrow_drop_down)
              ],
            ),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.getLogs();
        },
        child: Column(
          children: [
            const SizedBox(
              height: 5,
            ),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Obx(() => _itemTop(
                      title: 'Thu',
                      money: controller.totalThu.value,
                      color: Colors.blue)),
                  Obx(() => _itemTop(
                      title: 'Chi',
                      money: controller.totalChi.value,
                      color: AppColors.primaryColor)),
                  Obx(() =>
                      _itemTop(title: 'Tổng', money: controller.total.value))
                ],
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Expanded(
                child: Obx(() => (controller.mapLogs.value.isNotEmpty)
                    ? ListView.separated(
                        itemBuilder: (context, index) {
                          int total = 0;
                          for (var item in controller.mapLogs.value[
                              controller.mapLogs.value.keys.toList()[index]]!) {
                            if (item.type == 1) {
                              total += item.money!;
                            } else {
                              total -= item.money!;
                            }
                          }
                          return ExpendWidget(
                            date: controller
                                .mapLogs
                                .value[controller.mapLogs.value.keys
                                    .toList()[index]]!
                                .first
                                .dateCreated!,
                            list: controller.mapLogs.value[
                                controller.mapLogs.value.keys.toList()[index]]!,
                            total: total,
                            onTap: (LogsResponseModel model) {
                              Get.toNamed(EditExpensesPage.routeName, arguments: model);
                            },
                          );
                        },
                        itemCount:
                            controller.mapLogs.value.keys.toList().length,
                        separatorBuilder: (BuildContext context, int index) {
                          return const SizedBox(
                            height: 10,
                          );
                        },
                      )
                    : const SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        child: EmptyStateWidget(
                          text: 'Chưa có nhật ký',
                        ))))
          ],
        ),
      ),
    );
  }

  Widget _itemTop(
          {required String title,
          required int money,
          Color color = Colors.black}) =>
      Column(
        children: [
          TextWidget(
            textAlign: TextAlign.center,
            text: title,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(
            height: 5,
          ),
          TextWidget(
            textAlign: TextAlign.center,
            text: NumberUtils.formatCurrencyNotSymbol(money),
            color: color,
          )
        ],
      );
}
