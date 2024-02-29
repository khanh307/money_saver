import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:money_saver/pages/home/home_controller.dart';
import 'package:money_saver/utils/const/app_colors.dart';
import 'package:money_saver/utils/number_utils.dart';
import 'package:money_saver/widgets/empty_data.dart';
import 'package:money_saver/widgets/pie_chart.dart';
import 'package:money_saver/widgets/text_widget.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tổng quan'),
        actions: [
          PopupMenuButton(
            onSelected: (value) async {
              if (value == 1) {
                await controller.backupDB();
              } else {
                await controller.restoreDB();
              }
            },
            surfaceTintColor: Colors.white,
            itemBuilder: (BuildContext context) => <PopupMenuEntry>[
              const PopupMenuItem(
                value: 1,
                child: Text('Sao lưu dữ liệu'),
              ),
              const PopupMenuItem(
                value: 2,
                child: Text('Khôi phục dữ liệu'),
              ),
            ],
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.reloadData();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
                      height: 200,
                      width: Get.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: SvgPicture.asset(
                            'assets/images/background.svg',
                            fit: BoxFit.cover,
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const TextWidget(
                            text: 'Tài khoản',
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            size: 18,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Obx(() => TextWidget(
                                text: controller.user.value.toUpperCase(),
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                size: 18,
                              )),
                          const SizedBox(
                            height: 15,
                          ),
                          const Center(
                              child: TextWidget(
                            text: 'Tổng tài sản',
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            size: 16,
                          )),
                          Center(
                              child: Obx(() => TextWidget(
                                    text: NumberUtils.formatCurrencyVND(
                                        controller.total.value),
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    size: 20,
                                  ))),
                          const SizedBox(
                            height: 15,
                          ),
                          Obx(() => TextWidget(
                                text:
                                    'Khoản thu: ${NumberUtils.formatCurrencyVND(controller.totalThu.value)}',
                                color: Colors.white,
                              )),
                          const SizedBox(
                            height: 5,
                          ),
                          Obx(() => TextWidget(
                                text:
                                    'Khoản chi: ${NumberUtils.formatCurrencyVND(controller.totalChi.value)}',
                                color: Colors.white,
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  width: Get.width,
                  padding: const EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.0),
                      color: Colors.white),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const TextWidget(
                            text: 'Tài khoản',
                            fontWeight: FontWeight.bold,
                          ),
                          InkWell(
                            onTap: () {
                              controller.showDialogNewAccount();
                            },
                            child: const TextWidget(
                              text: 'Thêm mới',
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const Divider(
                        color: AppColors.primaryColor,
                      ),
                      Obx(() => (controller.accounts.isNotEmpty)
                          ? ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 50,
                                          height: 50,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(1000.0),
                                              color: Colors.blue),
                                          child: TextWidget(
                                            text: '${index + 1}',
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            size: 20,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        TextWidget(
                                          text: controller.accounts[index]
                                                  .accountName ??
                                              '',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ],
                                    ),
                                    TextWidget(
                                        text: NumberUtils.formatCurrency(
                                            controller.accounts[index]
                                                    .accountMoney ??
                                                0))
                                  ],
                                );
                              },
                              separatorBuilder: (context, index) {
                                return const Divider();
                              },
                              itemCount: controller.accounts.length)
                          : const EmptyStateWidget(
                              text: 'Chưa có tài khoản',
                            )),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  width: Get.width,
                  padding: const EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.0),
                      color: Colors.white),
                  child: Column(
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextWidget(
                            text: 'Khoản chi',
                            fontWeight: FontWeight.bold,
                          ),
                          TextWidget(
                            text: 'Xem chi tiết',
                            color: Colors.green,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const Divider(
                        color: AppColors.primaryColor,
                      ),
                      Obx(() => PieChart(
                            chartData: controller.dataChi.value,
                            textEmpty: 'Chưa có khoản chi',
                          ))
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  width: Get.width,
                  padding: const EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.0),
                      color: Colors.white),
                  child: Column(
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextWidget(
                            text: 'Khoản thu',
                            fontWeight: FontWeight.bold,
                          ),
                          TextWidget(
                            text: 'Xem chi tiết',
                            color: Colors.green,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const Divider(
                        color: AppColors.primaryColor,
                      ),
                      Obx(() => PieChart(
                            chartData: controller.dataThu.value,
                            textEmpty: 'Chưa có khoản thu',
                          ))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
