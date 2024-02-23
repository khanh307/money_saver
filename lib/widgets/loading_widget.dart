
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Lottie.asset('assets/jsons/loading_pnf.json',
        width: 150, height: 150, fit: BoxFit.cover);
  }
}
