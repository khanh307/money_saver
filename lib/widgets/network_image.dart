import 'package:flutter/material.dart';

class NetworkImageWidget extends StatelessWidget {
  final String image;
  final BoxFit boxFit;

  const NetworkImageWidget({super.key, required this.image, this.boxFit = BoxFit.cover});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      image,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        // Đặt hình ảnh mặc định tại đây
        return Image.asset('assets/images/no_image.png', fit: boxFit);
      },
    );
  }
}
