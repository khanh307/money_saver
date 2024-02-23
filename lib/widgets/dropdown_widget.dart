import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_saver/utils/const/app_colors.dart';

class DropdownWidget extends StatefulWidget {
  final String? hintText;
  final IconData? prefixIcon;
  final Function(dynamic value) onChange;
  final Function(dynamic)? validator;
  final List<DropDownItem> items;
  final bool isExpanded;
  final VoidCallback? onTap;
  dynamic value;
  final double? height;

  DropdownWidget(
      {super.key,
      this.hintText,
      this.validator,
      this.prefixIcon,
      required this.items,
      this.isExpanded = true,
      this.value,
      required this.onChange,
      this.height, this.onTap});

  @override
  State<DropdownWidget> createState() => _DropdownWidgetState();
}

class _DropdownWidgetState extends State<DropdownWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.onTap != null) {
          print('onTap Widget');
          widget.onTap!();
        }
      },
      child: SizedBox(
        height: widget.height ?? 59.0,
        child: DropdownButtonFormField(
          validator: (widget.validator != null)
              ? (dynamic value) {
                  return widget.validator!(value);
                }
              : null,
          value: widget.value,
          isExpanded: widget.isExpanded,
          dropdownColor: Colors.white,
          style: const TextStyle(
              color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.w500),
          menuMaxHeight: Get.height * 0.6,
          decoration: InputDecoration(
            labelText: widget.hintText,
            contentPadding: (widget.height != null)
                ? const EdgeInsets.symmetric(horizontal: 12.0)
                : null,
            hintText: widget.hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(56.0),
              borderSide: const BorderSide(color: AppColors.textColor, width: 1.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
              borderSide: const BorderSide(color: AppColors.textColor, width: 1.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
              borderSide:
                  const BorderSide(color: AppColors.primaryColor, width: 1.0),
            ),
            floatingLabelStyle: const TextStyle(
              color: Colors.black,
            ),
            fillColor: Colors.white,
            filled: true,
            prefixIcon: widget.prefixIcon == null
                ? null
                : Icon(
                    widget.prefixIcon,
                    color: const Color.fromRGBO(105, 108, 121, 1),
                  ),
            hintStyle: const TextStyle(
              height: 1.0,
              fontSize: 14.0,
              color: Color.fromRGBO(124, 124, 124, 1),
              fontWeight: FontWeight.w600,
            ),
          ),
          selectedItemBuilder: (context) {
            return widget.items.map((e) => Text(e.name)).toList();
          },
          items: widget.items
              .map((e) => DropdownMenuItem(
                    value: e.value,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          title: Text(e.name),
                          contentPadding: EdgeInsets.zero,
                        ),
                        (e == widget.items.last)
                            ? Container()
                            : Container(
                                width: Get.width,
                                height: 1,
                                color: AppColors.textGrey,
                              )
                      ],
                    ),
                  ))
              .toList(),

          onChanged: (value) {
            widget.onChange(value);
            setState(() {
              widget.value = value;
            });
          },
        ),
      ),
    );
  }
}

class DropDownItem {
  final dynamic value;
  final String name;

  DropDownItem(this.value, this.name);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DropDownItem &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;
}
