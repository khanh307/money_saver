import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:money_saver/utils/const/app_colors.dart';
import 'package:money_saver/widgets/text_widget.dart';

class EmptyStateWidget extends StatelessWidget {
  final String? text;

  const EmptyStateWidget({super.key, this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: Get.width,
        height: Get.width / 2,
        alignment: Alignment.bottomCenter,
        child: Column(
          children: [
            Expanded(
                child: Lottie.asset('assets/jsons/empty_state.json',
                    fit: BoxFit.cover)),
            TextWidget(
              text: text ?? 'Chưa có dữ liệu',
              color: AppColors.textColor,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
