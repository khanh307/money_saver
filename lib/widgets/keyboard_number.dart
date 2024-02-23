import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:money_saver/widgets/text_widget.dart';

class KeyboardNumber extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;

  const KeyboardNumber({super.key, required this.controller, required this.focusNode});

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: '');
    _insertText(String textToInsert) {
      if (controller.selection.start >= 0) {
        int newPosition = controller.selection.start + textToInsert.length;
        controller.text = controller.text.replaceRange(
          controller.selection.start,
          controller.selection.end,
          textToInsert,
        );
        controller.selection = TextSelection(
          baseOffset: newPosition,
          extentOffset: newPosition,
        );
      } else {
        controller.text += textToInsert;
      }
      if (controller.text.isNotEmpty) {
        final int value = formatter.parse(controller.text.trim().replaceAll('.', '')).toInt();
        final String newText = formatter.format(value);
        controller.text = newText.trim();
      }
    }

    return Container(
      width: Get.width,
      // height: 250,
      color: Colors.grey,
      child: Column(
        children: [
          Row(
            children: [
              cell('7', (value) {
                _insertText(value);
              }),
              cell('8', (value) {
                _insertText(value);
              }),
              cell('9', (value) {
                _insertText(value);
              }),
              GestureDetector(
                onTap: () {
                  if (controller.text.isNotEmpty) {
                    controller.text =
                        controller.text.substring(0, controller.text.length - 1);
                  }
                  FocusScope.of(Get.context!).requestFocus(focusNode);
                },
                child: Container(
                  width: Get.width / 4 - 4,
                  height: 55,
                  margin: const EdgeInsets.only(
                      top: 1, bottom: 1, left: 2, right: 2),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.backspace,
                      color: Colors.black,
                    ),
                  ),
                ),
              )
            ],
          ),
          Row(
            children: [
              cell('4', (value) {
                _insertText(value);
              }),
              cell('5', (value) {
                _insertText(value);
              }),
              cell('6', (value) {
                _insertText(value);
              }),
              cell('', (value) {})
            ],
          ),
          Row(
            children: [
              cell('1', (value) {
                _insertText(value);
              }),
              cell('2', (value) {
                _insertText(value);
              }),
              cell('3', (value) {
                _insertText(value);
              }),
              cell('', (value) {})
            ],
          ),
          Row(
            children: [
              cell('0', (value) {
                if (controller.text.isNotEmpty) {
                  _insertText(value);
                }
              }),
              cell('000', (value) {
                if (controller.text.isNotEmpty) {
                  _insertText(value);
                }
              }),
              cell('', (value) {}),
              cell('Xong', (value) {})
            ],
          )
        ],
      ),
    );
  }

  Widget cell(String text, Function(String value) onTap) => GestureDetector(
        onTap: () {
          onTap(text);
          FocusScope.of(Get.context!).requestFocus(focusNode);
        },
        child: Container(
          width: Get.width / 4 - 4,
          height: 55,
          margin: const EdgeInsets.only(top: 1, bottom: 1, left: 2, right: 2),
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Center(
            child: TextWidget(
              text: text,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
}
