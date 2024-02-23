import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_saver/pages/edit_expenses/edit_expenses_controller.dart';

import 'package:money_saver/utils/const/app_colors.dart';
import 'package:money_saver/widgets/button_underline.dart';
import 'package:money_saver/widgets/button_widget.dart';
import 'package:money_saver/widgets/date_picker_widget.dart';
import 'package:money_saver/widgets/input_widget.dart';
import 'package:money_saver/widgets/keyboard_number.dart';
import 'package:money_saver/widgets/text_widget.dart';
import 'package:money_saver/widgets/time_picker_widget.dart';

class EditExpensesPage extends GetView<EditExpensesController> {
  static const String routeName = '/editExpenses';

  const EditExpensesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thêm mới'),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    const Expanded(
                        flex: 1,
                        child: TextWidget(
                          text: 'Ngày',
                          color: AppColors.textGrey,
                        )),
                    Expanded(
                      flex: 2,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Obx(() => DatePickerWidget(
                                  value: controller.dateSelected.value,
                                  onChanged: (value) {
                                    controller.dateSelected.value = value;
                                  },
                                )),
                          ),
                          Expanded(
                            flex: 1,
                            child: Obx(() => TimePickerWidget(
                                  value: controller.timeSelected.value,
                                  onChanged: (value) {
                                    controller.timeSelected.value = value;
                                  },
                                )),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    const Expanded(
                        flex: 1,
                        child: TextWidget(
                          text: 'Tài khoản',
                          color: AppColors.textGrey,
                        )),
                    Expanded(
                        flex: 2,
                        child: Obx(() => ButtonUnderline(
                              value: (controller.accountSelected.value == null)
                                  ? null
                                  : controller
                                      .accountSelected.value!.accountName,
                              onTap: () {
                                controller.showBottomAccount();
                              },
                            )))
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    const Expanded(
                        flex: 1,
                        child: TextWidget(
                          text: 'Thể loại',
                          color: AppColors.textGrey,
                        )),
                    Expanded(
                        flex: 2,
                        child: Obx(() => ButtonUnderline(
                              value: (controller.categorySelected.value == null)
                                  ? null
                                  : controller
                                      .categorySelected.value!.categoryName,
                              onTap: () {
                                controller.showBottomCategory();
                              },
                            )))
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    const Expanded(
                        flex: 1,
                        child: TextWidget(
                          text: 'Số tiền',
                          color: AppColors.textGrey,
                        )),
                    Expanded(
                        flex: 2,
                        child: InputWidget(
                          focusNode: controller.moneyFocusNode,
                          readOnly: true,
                          controller: controller.moneyController,
                        ))
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    const Expanded(
                        flex: 1,
                        child: TextWidget(
                          text: 'Ghi chú',
                          color: AppColors.textGrey,
                        )),
                    Expanded(
                        flex: 2,
                        child: InputWidget(
                          controller: controller.noteController,
                        ))
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: ButtonWidget(
                        text: 'Cập nhật',
                        isResponsive: true,
                        backgroundColor: Colors.blue,
                        onPressed: () async {
                          await controller.updateLogs();
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      flex: 1,
                      child: ButtonWidget(
                        text: 'Xóa',
                        onPressed: () async {
                          await controller.deleteLogs();
                        },
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Obx(() => (controller.showKeyboardNumber.value)
          ? Container(
              width: Get.width,
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(15.0),
                    width: Get.width,
                    color: AppColors.primaryColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const TextWidget(
                          text: 'Số tiền',
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        InkWell(
                            onTap: () {
                              controller.showKeyboardNumber.value = false;
                            },
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                            ))
                      ],
                    ),
                  ),
                  KeyboardNumber(
                    controller: controller.moneyController,
                    focusNode: controller.moneyFocusNode,
                  ),
                  const SizedBox(
                    height: 50,
                  )
                ],
              ),
            )
          : Container(
              height: 0,
            )),
    );
  }
}
