import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_saver/pages/new_expenses/new_expenses_controller.dart';
import 'package:money_saver/utils/const/app_colors.dart';
import 'package:money_saver/utils/text_field_format/currency_text_format.dart';
import 'package:money_saver/widgets/button_underline.dart';
import 'package:money_saver/widgets/button_widget.dart';
import 'package:money_saver/widgets/date_picker_widget.dart';
import 'package:money_saver/widgets/input_widget.dart';
import 'package:money_saver/widgets/keyboard_number.dart';
import 'package:money_saver/widgets/text_widget.dart';
import 'package:money_saver/widgets/time_picker_widget.dart';

class NewExpensesPage extends GetView<NewExpensesController> {
  const NewExpensesPage({super.key});

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
                ButtonWidget(
                  text: 'Thêm mới',
                  isResponsive: true,
                  backgroundColor: Colors.blue,
                  onPressed: () async {
                    await controller.newLogs();
                  },
                )
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        width: Get.width,
        color: AppColors.backgroundColor.withOpacity(0.5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(15.0),
              width: Get.width,
              color: AppColors.primaryColor,
              child: const TextWidget(
                text: 'Số tiền',
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 5,),
            KeyboardNumber(
              controller: controller.moneyController,
              focusNode: controller.moneyFocusNode,
            ),
            const SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }
}
