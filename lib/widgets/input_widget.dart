import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:money_saver/utils/const/app_colors.dart';

class InputWidget extends StatelessWidget {
  final String? hintText;
  final String? labelText;
  final IconData? suffixIcon;
  final String? initValue;
  final bool obscureText;
  final TextInputType keyboardType;
  final IconData? prefixIcon;
  final Function()? onTapSuffix;
  final TextEditingController? controller;
  final Function(String? value)? validator;
  final AutovalidateMode autovalidateMode;
  final List<TextInputFormatter>? inputFormater;
  final bool outline;
  final double? height;
  final bool isEnable;
  final int? maxLenght;
  final String? suffixText;
  final int? maxLines;
  final bool? readOnly;
  final bool isDelay;
  final bool? showCursor;
  final Function(String value)? onChange;
  final FocusNode? focusNode;

  const InputWidget(
      {super.key,
      this.height,
      this.initValue,
      this.hintText,
      this.obscureText = false,
      this.isEnable = true,
      this.suffixIcon,
      this.prefixIcon,
      this.maxLenght,
      this.outline = false,
      this.keyboardType = TextInputType.text,
      this.autovalidateMode = AutovalidateMode.onUserInteraction,
      this.controller,
      this.onTapSuffix,
      this.validator,
      this.onChange,
      this.suffixText,
      this.labelText,
      this.inputFormater,
      this.maxLines,
      this.isDelay = true,
      this.readOnly,
      this.showCursor, this.focusNode});

  @override
  Widget build(BuildContext context) {
    final _debouncer = Debouncer(milliseconds: 800);
    return SizedBox(
      height: height,
      child: TextFormField(
        focusNode: focusNode,
        validator: (validator != null)
            ? (value) {
                return validator!(value);
              }
            : null,
        controller: controller,
        autovalidateMode: autovalidateMode,
        onChanged: (value) {
          if (onChange != null) {
            if (isDelay) {
              _debouncer.run(() {
                onChange!(value);
              });
            } else {
              onChange!(value);
            }
          }
        },
        readOnly: readOnly ?? false,
        showCursor: showCursor ?? true,
        maxLines: maxLines ?? 1,
        initialValue: initValue,
        contextMenuBuilder: (context, editableTextState) {
          final List<ContextMenuButtonItem> buttonItems =
              editableTextState.contextMenuButtonItems;
          return AdaptiveTextSelectionToolbar.buttonItems(
            anchors: editableTextState.contextMenuAnchors,
            buttonItems: buttonItems,
          );
        },
        keyboardType: keyboardType,
        obscureText: obscureText,
        textAlignVertical: (height != null)
            ? TextAlignVertical.bottom
            : TextAlignVertical.center,
        textAlign: TextAlign.start,
        // enabled: isEnable,
        // onTapOutside: (event) {
        //   FocusScope.of(context).unfocus();
        // },
        maxLength: maxLenght,
        inputFormatters: inputFormater,
        style:
            const TextStyle(height: 1.2, fontSize: 14.0, color: Colors.black),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: hintText,
          labelText: labelText,
          labelStyle: const TextStyle(
              color: Color.fromRGBO(124, 124, 124, 1),
              fontSize: 14,
              fontWeight: FontWeight.w600),
          floatingLabelStyle:
              const TextStyle(color: Colors.black, fontSize: 14),
          hintStyle: const TextStyle(
            fontSize: 14.0,
            color: Color.fromRGBO(124, 124, 124, 1),
            fontWeight: FontWeight.w600,
          ),
          suffixText: suffixText,
          prefixIcon: prefixIcon == null
              ? null
              : Icon(
                  prefixIcon,
                  color: const Color.fromRGBO(105, 108, 121, 1),
                ),
          suffixIcon: suffixIcon == null
              ? null
              : InkWell(
                  onTap: onTapSuffix,
                  child: Icon(
                    suffixIcon,
                    color: const Color.fromRGBO(105, 108, 121, 1),
                  ),
                ),
          border: UnderlineInputBorder(
            borderSide: const BorderSide(color: AppColors.textColor, width: 2),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: const BorderSide(color: AppColors.textColor, width: 2),
          ),
          focusedErrorBorder: UnderlineInputBorder(
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          disabledBorder: UnderlineInputBorder(
            borderSide: const BorderSide(color: AppColors.textColor, width: 2),
          ),
          enabled: isEnable,
          focusedBorder: UnderlineInputBorder(
            borderSide:
                const BorderSide(color: AppColors.primaryColor, width: 2),
          ),
          errorBorder: UnderlineInputBorder(
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
        ),
      ),
    );
  }
}

class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  run(VoidCallback action) {
    if (null != _timer) {
      _timer!.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
