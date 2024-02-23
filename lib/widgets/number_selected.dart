import 'package:flutter/material.dart';
import 'package:money_saver/widgets/text_widget.dart';

@immutable
class NumberSelected extends StatefulWidget {
  final Function increase;
  final Function decrease;
  final Function(String value) onChange;
  final int initValue;

  const NumberSelected(
      {super.key,
      required this.increase,
      required this.decrease,
      required this.onChange,
      this.initValue = 1});

  @override
  State<NumberSelected> createState() => _NumberSelectedState();
}

class _NumberSelectedState extends State<NumberSelected> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(border: Border.all(color: Colors.grey, width: 1)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              widget.decrease();
            },
            child: Container(
              width: 30,
              height: 30,
              decoration: const BoxDecoration(
                  border:
                      Border(right: BorderSide(color: Colors.grey, width: 1))),
              child: const Icon(
                Icons.remove,
                size: 15,
              ),
            ),
          ),
          SizedBox(
            height: 30,
            width: 50,
            child: Center(
              child: TextWidget(
                text: widget.initValue.toString(),
                textAlign: TextAlign.center,

                maxLines: 1,
                size: 15,
                color: Colors.black,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              widget.increase();
            },
            child: Container(
              width: 30,
              height: 30,
              decoration: const BoxDecoration(
                  border:
                      Border(left: BorderSide(color: Colors.grey, width: 1))),
              child: const Icon(
                Icons.add,
                size: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
