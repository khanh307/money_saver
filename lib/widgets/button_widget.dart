import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_saver/utils/const/app_colors.dart';
import 'package:money_saver/widgets/text_widget.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  final Function() onPressed;
  final double width;
  final Color textColor;
  final double height;
  final Color backgroundColor;
  final bool isResponsive;

  const ButtonWidget(
      {super.key,
        required this.text,
        required this.onPressed,
        this.width = 150.0,
        this.height = 59.0,
        this.textColor = Colors.white,
        this.backgroundColor = AppColors.primaryColor,
        this.isResponsive = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        onPressed();
      },
      child: Container(
        height: height,
        width: (isResponsive) ? Get.width : width,
        decoration: BoxDecoration(
            color: backgroundColor, borderRadius: BorderRadius.circular(6.0)),
        child: Center(
          child: TextWidget(
            text: text.tr,
            color: Colors.white,
            size: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
