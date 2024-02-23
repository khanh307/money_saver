import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_saver/utils/const/app_colors.dart';
import 'package:money_saver/widgets/text_widget.dart';

class ButtonUnderline extends StatefulWidget {
  final VoidCallback onTap;
  final String? value;

  const ButtonUnderline({super.key, required this.onTap, this.value});

  @override
  State<ButtonUnderline> createState() => _ButtonUnderlineState();
}

class _ButtonUnderlineState extends State<ButtonUnderline> {
  bool isFocus = false;

  @override
  Widget build(BuildContext context) {
    return TapRegion(
      onTapInside: (event) {
        FocusScope.of(context).unfocus();
        widget.onTap();
        isFocus = true;
        setState(() {});
      },
      onTapOutside: (event) {
        isFocus = false;
        setState(() {});
      },
      child: Container(
        width: Get.width,
        height: 49,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(
                  color:
                      (isFocus) ? AppColors.primaryColor : AppColors.textColor,
                  width: 2),
            )),
        child: TextWidget(text: widget.value ?? '', color: Colors.black, fontWeight: FontWeight.w500,),
      ),
    );
  }
}
