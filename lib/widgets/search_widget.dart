import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_saver/utils/const/app_colors.dart';

import 'input_widget.dart';

class SearchWidget extends StatelessWidget {
  final String? hintText;
  final Function(String value) onSearch;
  final double? height;

  const SearchWidget(
      {super.key, this.hintText, required this.onSearch, this.height});

  @override
  Widget build(BuildContext context) {
    TextEditingController _controller = TextEditingController();
    return Row(
      children: [
        Flexible(
          child: InputWidget(
            height: height,
            controller: _controller,
            hintText: hintText ?? 'Tìm kiếm',
            // suffixIcon: Icons.clear,
            // onTapSuffix: () {
            //   _controller.clear();
            // },
          ),
        ),
        GestureDetector(
          onTap: () {
            if (_controller.text.isEmpty) return;
            onSearch(_controller.text);
          },
          child: Container(
            width: height ?? 58,
            height: height ?? 58,
            margin: const EdgeInsets.only(left: 5),
            decoration: BoxDecoration(
                border: Border.all(color: AppColors.textColor, width: 1),
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.0)),
            child: const Center(
              child: Icon(
                Icons.search,
                color: AppColors.primaryColor,
              ),
            ),
          ),
        )
      ],
    );
  }
}
