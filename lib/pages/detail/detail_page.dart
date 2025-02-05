import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_saver/pages/detail/detail_controller.dart';

import '../../models/log_response_model.dart';
import '../../widgets/empty_data.dart';
import '../../widgets/expend_detail_widget.dart';

class DetailPage extends GetView<DetailController> {
  static const String routeName = '/detail';

  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10,),
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
                        return ExpendDetailWidget(
                          category: controller.mapLogs.value.keys
                              .toList()[index]
                              .categoryName!,
                          list: controller.mapLogs.value[
                              controller.mapLogs.value.keys.toList()[index]]!,
                          total: total,
                          onTap: (LogsResponseModel model) {
                          },
                        );
                      },
                      itemCount: controller.mapLogs.value.keys.toList().length,
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
    );
  }
}
