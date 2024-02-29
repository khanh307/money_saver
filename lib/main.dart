import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_saver/bindings/all_bindings.dart';
import 'package:money_saver/routes/app_routes.dart';
import 'package:money_saver/utils/const/app_colors.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Phú Nông',
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.backgroundColor,
        cardColor: AppColors.backgroundCard,
        cardTheme: CardTheme(
            elevation: 5,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.0)),
            color: Colors.white,
            surfaceTintColor: Colors.white),
        dialogTheme: const DialogTheme(
            backgroundColor: Colors.white,
            elevation: 5,
            surfaceTintColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(6.0))),
            titleTextStyle: TextStyle(
                color: AppColors.primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 20)),
        datePickerTheme: const DatePickerThemeData(
          backgroundColor: Colors.white,
          elevation: 5,
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(6.0))),
        ),
        bottomSheetTheme: BottomSheetThemeData(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            modalBackgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.0))),
        appBarTheme: const AppBarTheme(
            elevation: 2,
            color: Colors.white,
            shadowColor: AppColors.textColor,
            surfaceTintColor: Colors.white,
            foregroundColor: Colors.black,
            titleTextStyle: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
                color: Colors.black)),
        useMaterial3: true,
      ),
      initialBinding: AllBindings(),
      initialRoute: AppRoutes.initialRoute,
      getPages: AppRoutes.pages,
    );
  }
}

