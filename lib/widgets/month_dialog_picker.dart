import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_saver/utils/const/app_colors.dart';
import 'package:money_saver/widgets/text_widget.dart';

class MonthDialogPicker {
  static showDialogPicker(BuildContext context,
      {required int year,
      required int month,
      required Function(int value) onChange,
      required Function(int value) onChangeYear}) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return Dialog(
                elevation: 0,
                alignment: Alignment.topRight,
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Container(
                      padding: const EdgeInsets.all(15),
                      width: Get.width,
                      decoration: const BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(6.0),
                              topLeft: Radius.circular(6.0))),
                      child: Stack(
                        children: [
                          const Align(
                            alignment: Alignment.center,
                            child: TextWidget(
                              text: 'Chọn tháng',
                              color: Colors.white,
                              lineHeight: 1.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: InkWell(
                              onTap: () {
                                Get.back();
                              },
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          year--;
                          onChangeYear(year);
                          setState(() {});
                        },
                        child: const Icon(
                          Icons.arrow_left,
                          size: 50,
                        ),
                      ),
                      TextWidget(
                        text: '$year',
                        fontWeight: FontWeight.bold,
                      ),
                      InkWell(
                        onTap: () {
                          year++;
                          onChangeYear(year);
                          setState(() {});
                        },
                        child: const Icon(
                          Icons.arrow_right,
                          size: 50,
                        ),
                      )
                    ],
                  ),
                  GridView.builder(
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4, childAspectRatio: 1.5),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          onChange(index + 1);
                          Get.back();
                        },
                        child: Container(
                          color: Colors.white,
                          margin: const EdgeInsets.all(2),
                          alignment: Alignment.center,
                          child: TextWidget(
                            textAlign: TextAlign.center,
                            text: 'Th${index + 1}',
                            fontWeight: FontWeight.bold,
                            color: (month == index + 1)
                                ? AppColors.primaryColor
                                : Colors.black,
                          ),
                        ),
                      );
                    },
                    itemCount: 12,
                  )
                ]));
          });
        });
  }
}
