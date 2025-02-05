import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_saver/models/log_response_model.dart';
import 'package:money_saver/utils/const/app_colors.dart';
import 'package:money_saver/utils/date_util.dart';
import 'package:money_saver/utils/number_utils.dart';
import 'package:money_saver/widgets/text_widget.dart';

class ExpendDetailWidget extends StatefulWidget {
  final String category;
  final List<LogsResponseModel> list;
  final int total;
  final Function(LogsResponseModel model) onTap;

  const ExpendDetailWidget(
      {super.key,
      required this.category,
      required this.list,
      required this.total,
      required this.onTap});

  @override
  State<ExpendDetailWidget> createState() => _ExpendDetailWidgetState();
}

class _ExpendDetailWidgetState extends State<ExpendDetailWidget> {
  bool isExpend = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  TextWidget(
                    text: widget.category,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
              Row(
                children: [
                  TextWidget(text: NumberUtils.formatCurrency(widget.total)),
                  InkWell(
                      onTap: () {
                        isExpend = !isExpend;
                        setState(() {});
                      },
                      child: const Icon(Icons.arrow_drop_down_sharp))
                ],
              )
            ],
          ),
          (isExpend) ? const Divider() : Container(),
          (isExpend)
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      LogsResponseModel model = widget.list[index];
                      return Container(
                        width: Get.width,
                        margin: const EdgeInsets.only(top: 4.0, bottom: 10.0),
                        child: GestureDetector(
                          onTap: () {
                            widget.onTap(model);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextWidget(
                                    text:
                                        DateUtil.formatDate(model.dateCreated!),
                                    fontWeight: FontWeight.w500,
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  TextWidget(
                                    text: model.account!.accountName ?? '',
                                    color: AppColors.textGrey,
                                    size: 14,
                                  )
                                ],
                              ),
                              TextWidget(
                                text: NumberUtils.formatCurrency(
                                    model.money ?? 0),
                                color: (model.type == 1)
                                    ? Colors.blue
                                    : AppColors.primaryColor,
                              )
                            ],
                          ),
                        ),
                      );
                    },
                    itemCount: widget.list.length,
                    separatorBuilder: (BuildContext context, int index) {
                      return Divider(
                        color: AppColors.textGrey.withOpacity(0.2),
                      );
                    },
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}
