import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_saver/pages/transfer/transfer_controller.dart';
import 'package:money_saver/utils/const/app_colors.dart';
import 'package:money_saver/widgets/button_underline.dart';
import 'package:money_saver/widgets/button_widget.dart';
import 'package:money_saver/widgets/input_widget.dart';
import 'package:money_saver/widgets/keyboard_number.dart';
import 'package:money_saver/widgets/text_widget.dart';

class TransferPage extends GetView<TransferController> {
  const TransferPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Chuyển tiền'),
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const TextWidget(
                      text: 'Tài khoản chuyển',
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    const Divider(
                      color: AppColors.primaryColor,
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
                                  value:
                                      (controller.fromAccountSelected.value == null)
                                          ? null
                                          : controller.fromAccountSelected.value!
                                              .accountName,
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
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const TextWidget(
                      text: 'Tài khoản nhận',
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    const Divider(
                      color: AppColors.primaryColor,
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
                                  value:
                                      (controller.toAccountSelected.value == null)
                                          ? null
                                          : controller.toAccountSelected.value!
                                              .accountName,
                                  onTap: () {
                                    controller.showBottomAccount(isFrom: false);
                                  },
                                )))
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ButtonWidget(
                      text: 'Lưu',
                      height: 50,
                      onPressed: ()async {
                        await controller.transfer();
                      },
                      isResponsive: true,
                      backgroundColor: Colors.blue,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
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
              const SizedBox(
                height: 5,
              ),
              KeyboardNumber(
                controller: controller.moneyController,
                focusNode: controller.moneyFocusNode,
              ),
              const SizedBox(
                height: 10,
              )
            ],
          ),
        ));
  }
}
