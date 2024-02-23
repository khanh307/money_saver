import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import 'package:money_saver/widgets/input_widget.dart';
import 'package:money_saver/widgets/loading_widget.dart';
import 'package:money_saver/widgets/search_widget.dart';
import 'package:money_saver/widgets/text_widget.dart';

import 'const/app_colors.dart';

class DialogUtil {
  static bool isShowedNotInternet = false;

  static void showSnackBar(String message) async {
    if (Get.isSnackbarOpen) {
      await Get.closeCurrentSnackbar();
    }
    Get.showSnackbar(GetSnackBar(
      message: message,
      borderRadius: 10,
      snackStyle: SnackStyle.FLOATING,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      duration: const Duration(milliseconds: 1500),
    ));
  }

  static Future showLoading({bool isClosed = true, VoidCallback? actionClose}) async {
    if (Get.isSnackbarOpen) {
      await Get.closeCurrentSnackbar();
    }
    Get.dialog(
        AlertDialog(
            elevation: 0,
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            insetPadding: EdgeInsets.zero,
            contentPadding:
                EdgeInsets.symmetric(horizontal: (Get.width - 100) / 2),
            actionsPadding: EdgeInsets.zero,
            content: WillPopScope(
              onWillPop: () async {
                if (isClosed) {
                  if (actionClose != null) {
                    actionClose();
                  }
                  Get.back();
                  Get.back();
                }
                return false;
              },
              child: Card(
                elevation: 10,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const LoadingWidget(),
                ),
              ),
            )),
        useSafeArea: false,
        barrierDismissible: false,
        barrierColor: Colors.white38);
  }

  static void hideLoading() async {
    Get.back();
  }

  static Future showDialog(
      {String title = '',
      required Widget content,
      EdgeInsets? titlePadding,
      EdgeInsets? contendPadding,
      List<ActionDialog>? actions,
      bool barrierDismissible = true}) async {
    await Get.defaultDialog(
        backgroundColor: Colors.white,
        titlePadding: titlePadding ??
            const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        contentPadding: contendPadding ??
            const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        barrierDismissible: barrierDismissible,
        radius: 8.0,
        title: title,
        content: WillPopScope(
          onWillPop: () async {
            return barrierDismissible;
          },
          child: SizedBox(
            width: Get.width,
            child: Column(
              children: [
                content,
                const SizedBox(
                  height: 20,
                ),
                (actions != null)
                    ? Container(
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(5)),
                        child: Row(
                          children: List.generate(
                              actions.length,
                              (index) => Expanded(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              actions[index].onPressed();
                                            },
                                            child: Container(
                                              width: 1000,
                                              child: TextWidget(
                                                text: actions[index].text,
                                                color: Colors.white,
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                        ),
                                        (index < actions.length - 1)
                                            ? Container(
                                                height: 40,
                                                color: Colors.white,
                                                width: 1,
                                              )
                                            : Container()
                                      ],
                                    ),
                                  )),
                        ),
                      )
                    : Container()
              ],
            ),
          ),
        ));
  }

  static Future showBottomSheetSearch(String title, Widget content,
      {required Function(String value) onSearch,
      bool searchWidget = false}) async {
    await Get.bottomSheet(
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15),
          height: Get.height * 0.65,
          child: Column(
            children: [
              TextWidget(
                text: title,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
              const SizedBox(
                height: 10,
              ),
              (!searchWidget)
                  ? InputWidget(
                      outline: true,
                      hintText: 'Tìm kiếm',
                      suffixIcon: Icons.search,
                      height: 55,
                      onChange: (value) {
                        onSearch(value);
                      },
                    )
                  : SearchWidget(
                      onSearch: (value) {
                        onSearch(value);
                      },
                      hintText: 'Tìm kiếm',
                      height: 55,
                    ),
              Expanded(child: content)
            ],
          ),
        ),
        backgroundColor: Colors.white,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)));
  }

  static Future showBottomSheet(String title, Widget content, {EdgeInsetsGeometry? padding, Color backgroundColor = Colors.white}) async {
    await Get.bottomSheet(
        Container(
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15),
          height: Get.height * 0.5,
          child: Column(
            children: [
              TextWidget(
                text: title,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(child: content)
            ],
          ),
        ),
        backgroundColor: backgroundColor,
        isScrollControlled: true,

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)));
  }

  static Future showDialogInternetError() async {
    if (isShowedNotInternet) return;
    isShowedNotInternet = true;
    await showDialog(
        content: Column(
          children: [
            Lottie.asset('assets/jsons/no_internet.json'),
            const TextWidget(
              text: 'Không tìm thấy kết nối mạng, vui lòng thử lại sau!',
              textAlign: TextAlign.center,
            )
          ],
        ),
        title: 'Lỗi kết nối mạng',
        barrierDismissible: false,
        actions: [
          ActionDialog(
            text: 'OK',
            onPressed: () {
              Get.back();
              isShowedNotInternet = false;
            },
          )
        ]);
  }

  static void showDialogNoPermission() {
    showDialog(
        title: 'Thông báo',
        content: const TextWidget(
          text: 'Bạn không có quyền truy cập chức năng này!',
          textAlign: TextAlign.center,
        ),
        actions: [
          ActionDialog(
            text: 'OK',
            onPressed: () {
              Get.back();
            },
          )
        ]);
  }

  static void showDialogSuccess({required String text, VoidCallback? action}) {
    Get.dialog(
      WillPopScope(
        onWillPop: () async {
          if (action != null) {
            action();
          }
          return true;
        },
        child: AlertDialog(
          titlePadding: EdgeInsets.zero,
          backgroundColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          title: Stack(
            children: [
              Container(
                width: Get.width,
                height: 200,
                decoration: const BoxDecoration(
                    color: Color(0xFF2dd284),
                    // color: AppColors.primaryColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(6.0),
                        topRight: Radius.circular(6.0))),
                child: Image.asset('assets/images/success.png'),
              ),
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                    onPressed: () {
                      Get.back();
                      if (action != null) {
                        action();
                      }
                    },
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                    )),
              )
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 20,
              ),
              TextWidget(
                text: text,
                textAlign: TextAlign.center,
                size: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textColor,
              ),
              const SizedBox(
                height: 20,
              ),
              // GestureDetector(
              //   onTap: () {
              //     Get.back();
              //   },
              //   child: Container(
              //     height: 50,
              //     alignment: Alignment.center,
              //     decoration: BoxDecoration(
              //         color: const Color(0xFF2a79bf),
              //         borderRadius: BorderRadius.circular(5)),
              //     child: const TextWidget(
              //       text: 'OK',
              //       color: Colors.white,
              //       textAlign: TextAlign.center,
              //     ),
              //   ),
              // )
            ],
          ),
        ),
      ),
      useSafeArea: false,
      barrierDismissible: true,
    );
  }

  static void showDialogError({required String text, VoidCallback? action}) {
    Get.dialog(
      WillPopScope(
        onWillPop: () async {
          if (action != null) {
            action();
          }
          return true;
        },
        child: AlertDialog(
          titlePadding: EdgeInsets.zero,
          backgroundColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          title: Stack(
            children: [
              Container(
                width: Get.width,
                height: 200,
                decoration: const BoxDecoration(
                    color: Color(0xFFe95350),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(6.0),
                        topRight: Radius.circular(6.0))),
                child: Image.asset('assets/images/error.png'),
              ),
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                    onPressed: () {
                      Get.back();
                      if (action != null) {
                        action();
                      }
                    },
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                    )),
              )
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 20,
              ),
              TextWidget(
                text: text,
                textAlign: TextAlign.center,
                size: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textColor,
              ),
              const SizedBox(
                height: 20,
              ),
              // GestureDetector(
              //   onTap: () {
              //     Get.back();
              //   },
              //   child: Container(
              //     height: 50,
              //     alignment: Alignment.center,
              //     decoration: BoxDecoration(
              //         color: const Color(0xFF2a79bf),
              //         borderRadius: BorderRadius.circular(5)),
              //     child: const TextWidget(
              //       text: 'OK',
              //       color: Colors.white,
              //       textAlign: TextAlign.center,
              //     ),
              //   ),
              // )
            ],
          ),
        ),
      ),
      useSafeArea: false,
      barrierDismissible: true,
    );
  }

  static void showDialogWarning({required String text, VoidCallback? action}) {
    Get.dialog(
      WillPopScope(
        onWillPop: () async {
          if (action != null) {
            action();
          }
          return true;
        },
        child: AlertDialog(
          titlePadding: EdgeInsets.zero,
          backgroundColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          title: Stack(
            children: [
              Container(
                width: Get.width,
                height: 200,
                decoration: BoxDecoration(
                    color: const Color(0xFFffc822).withOpacity(0.8),
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(6.0),
                        topRight: Radius.circular(6.0))),
                child: Image.asset('assets/images/warning.png'),
              ),
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                    onPressed: () {
                      Get.back();
                      if (action != null) {
                        action();
                      }
                    },
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                    )),
              )
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 20,
              ),
              TextWidget(
                text: text,
                textAlign: TextAlign.center,
                size: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textColor,
              ),
              const SizedBox(
                height: 20,
              ),
              // GestureDetector(
              //   onTap: () {
              //     Get.back();
              //   },
              //   child: Container(
              //     height: 50,
              //     alignment: Alignment.center,
              //     decoration: BoxDecoration(
              //         color: const Color(0xFF2a79bf),
              //         borderRadius: BorderRadius.circular(5)),
              //     child: const TextWidget(
              //       text: 'OK',
              //       color: Colors.white,
              //       textAlign: TextAlign.center,
              //     ),
              //   ),
              // )
            ],
          ),
        ),
      ),
      useSafeArea: false,
      barrierDismissible: true,
    );
  }
}

class ActionDialog {
  String text;
  Function() onPressed;

  ActionDialog({required this.text, required this.onPressed});
}
