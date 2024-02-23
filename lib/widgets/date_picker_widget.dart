import 'package:flutter/material.dart';
import 'package:money_saver/utils/const/app_colors.dart';
import 'package:money_saver/utils/date_util.dart';

class DatePickerWidget extends StatefulWidget {
  final String? hintText;
  final IconData? prefixIcon;
  DateTime? value;
  final double? height;
  final Function(String?)? validator;
  final Function(DateTime value) onChanged;

  DatePickerWidget(
      {super.key,
      this.hintText,
      this.height,
      this.prefixIcon,
      this.validator,
      this.value,
      required this.onChanged});

  @override
  State<DatePickerWidget> createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    widget.value ??= DateTime.now();
    _controller.text = DateUtil.formatDate(widget.value!);
    super.initState();
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime selectedDate;
    if (widget.value != null) {
      selectedDate = widget.value!;
    } else {
      selectedDate = DateTime.now();
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.value ?? DateTime.now(),
      firstDate: DateTime(1800),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        widget.value = selectedDate;
        _controller.text = DateUtil.formatDate(selectedDate);
        widget.onChanged(selectedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await _selectDate(context);
      },
      child: SizedBox(
        height: widget.height ?? 59.0,
        child: TextFormField(
          controller: _controller,
          validator: (widget.validator != null)
              ? (value) {
                  return widget.validator!(value);
                }
              : null,
          textAlignVertical: TextAlignVertical.center,
          enabled: false,
          style: const TextStyle(
              color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.w600),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: widget.hintText,
            hintStyle: const TextStyle(
              fontSize: 14.0,
              color: Color.fromRGBO(124, 124, 124, 1),
              fontWeight: FontWeight.w600,
            ),
            prefixIcon: widget.prefixIcon == null
                ? null
                : Icon(
                    widget.prefixIcon,
                    color: const Color.fromRGBO(105, 108, 121, 1),
                  ),
            border: const UnderlineInputBorder(
              borderSide:
                  BorderSide(color: AppColors.textColor, width: 2),
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide:
                  BorderSide(color: AppColors.textColor, width: 2),
            ),
            contentPadding: (widget.height != null)
                ? const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0)
                : null,
            focusedErrorBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 2),
            ),
            disabledBorder: const UnderlineInputBorder(
              borderSide:
                  BorderSide(color: AppColors.textColor, width: 2),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide:
                  BorderSide(color: AppColors.primaryColor, width: 2),
            ),
            errorBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 2),
            ),
          ),
        ),
      ),
    );
  }
}
