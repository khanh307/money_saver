import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:money_saver/models/account_model.dart';
import 'package:money_saver/models/category_model.dart';
import 'package:money_saver/models/logs_model.dart';
import 'package:money_saver/pages/home/home_controller.dart';
import 'package:money_saver/pages/logs_page/logs_controller.dart';
import 'package:money_saver/pages/new_expenses/new_expenses_service.dart';
import 'package:money_saver/services/sql_service.dart';
import 'package:money_saver/utils/const/app_colors.dart';
import 'package:money_saver/utils/dialog_util.dart';
import 'package:money_saver/utils/number_utils.dart';
import 'package:money_saver/utils/text_field_format/currency_text_format.dart';
import 'package:money_saver/widgets/input_widget.dart';
import 'package:money_saver/widgets/tab_widget.dart';
import 'package:money_saver/widgets/text_widget.dart';

class NewExpensesController extends GetxController {
  static NewExpensesController get instants => Get.find();
  TextEditingController moneyController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  final NewExpensesSqlService _sqlService = NewExpensesSqlService();
  FocusNode moneyFocusNode = FocusNode();
  RxBool showKeyboardNumber = false.obs;
  RxList<AccountModel> accounts = <AccountModel>[].obs;
  Rx<AccountModel?> accountSelected = Rx(null);
  RxList<CategoryModel> categoriesChi = <CategoryModel>[].obs;
  RxList<CategoryModel> categoriesThu = <CategoryModel>[].obs;
  Rx<CategoryModel?> categorySelected = Rx(null);
  Rx<DateTime> dateSelected = Rx(DateTime.now());
  Rx<TimeOfDay> timeSelected = Rx(TimeOfDay.now());
  RxInt type = 0.obs;

  @override
  void onInit() {
    super.onInit();
    moneyFocusNode.addListener(() {
      if (moneyFocusNode.hasFocus) {
        showKeyboardNumber.value = true;
      } else {
        showKeyboardNumber.value = false;
      }
    });
  }

  Future reloadData() async {
    moneyController.clear();
    noteController.clear();
    accountSelected.value = null;
    categorySelected.value = null;
    dateSelected.value = DateTime.now();
    timeSelected.value = TimeOfDay.now();
    await getAccounts();
    await getCategoriesChi();
    await getCategoriesThu();
  }

  @override
  void onReady() async {
    await getAccounts();
    await getCategoriesChi();
    await getCategoriesThu();
    super.onReady();
  }

  Future getAccounts() async {
    accounts.clear();
    await DialogUtil.showLoading();
    final data = await _sqlService.getAccounts();
    accounts.addAll(data);
    DialogUtil.hideLoading();
  }

  Future getCategoriesChi() async {
    categoriesChi.clear();
    final data = await _sqlService.getCategories(2);
    categoriesChi.addAll(data);
  }

  Future getCategoriesThu() async {
    categoriesThu.clear();
    final data = await _sqlService.getCategories(1);
    categoriesThu.addAll(data);
  }

  Future newLogs() async {
    if (accountSelected.value == null) {
      DialogUtil.showDialogWarning(text: 'Vui lòng chọn tài khoản');
      return;
    }
    if (categorySelected.value == null) {
      DialogUtil.showDialogWarning(text: 'Vui lòng chọn thể loại');
      return;
    }
    if (moneyController.text.isEmpty) {
      DialogUtil.showDialogWarning(text: 'Vui lòng nhập số tiền');
      return;
    }
    await DialogUtil.showLoading();
    LogsModel data = LogsModel(
        money: NumberUtils.parse(moneyController.text),
        accountId: accountSelected.value!.accountId,
        categoryId: categorySelected.value!.categoryId,
        dateCreated: dateSelected.value.copyWith(
            hour: timeSelected.value.hour, minute: timeSelected.value.minute),
        note: noteController.text);

    final result = await _sqlService.newLogs(data, categorySelected.value!);
    if (result != 0) {
      DialogUtil.hideLoading();
      DialogUtil.showDialogSuccess(
        text: 'Thêm mới thành công',
        action: () async {
          await HomeController.instants.reloadData();
          await reloadData();
        },
      );
    } else {
      DialogUtil.hideLoading();
      DialogUtil.showDialogError(text: 'Thêm mới thất bại');
    }
  }

  void showBottomAccount() async {
    DialogUtil.showBottomSheet(
        'Chọn tài khoản',
        Obx(() => GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 4.0,
                  crossAxisSpacing: 4.0,
                  childAspectRatio: 1.8),
              itemBuilder: (context, index) {
                if (index < accounts.length) {
                  return GestureDetector(
                    onLongPress: () {
                      showDialogUpdateAccount(accounts[index]);
                    },
                    onTap: () {
                      accountSelected.value = accounts[index];
                      Get.back();
                    },
                    child: Card(
                      child: Container(
                        padding: const EdgeInsets.all(4.0),
                        color: Colors.white,
                        child: Center(
                          child: TextWidget(
                            text: accounts[index].accountName ?? '',
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  return GestureDetector(
                    onTap: () async {
                      showDialogNewAccount();
                    },
                    child: Card(
                      child: Container(
                        padding: const EdgeInsets.all(4.0),
                        color: Colors.white,
                        child: const Center(
                          child: TextWidget(
                            text: '+',
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  );
                }
              },
              itemCount: accounts.length + 1,
            )),
        backgroundColor: AppColors.backgroundColor);
  }

  void showDialogNewAccount() async {
    TextEditingController controller = TextEditingController();
    TextEditingController moneyAccountController = TextEditingController(text: '0');
    DialogUtil.showDialog(
        title: 'Thêm tài khoản',
        content: Column(
          children: [
            InputWidget(
              hintText: 'Nhập tên tài khoản',
              controller: controller,
            ),
            const SizedBox(height: 10,),
            InputWidget(
              hintText: 'Nhập tiền trong tài khoản',
              controller: moneyAccountController,
              keyboardType: TextInputType.number,
              inputFormater: [
                FilteringTextInputFormatter.digitsOnly,
                CurrencyTextFormat()
              ],
            ),
          ],
        ),
        actions: [
          ActionDialog(
            text: 'HỦY',
            onPressed: () {
              Get.back();
            },
          ),
          ActionDialog(
            text: 'OK',
            onPressed: () async {
              AccountModel data = AccountModel();
              data.accountName = controller.text;
              data.accountMoney = int.parse(moneyAccountController.text.replaceAll('.', ''));
                  int result = await _sqlService.newAccount(data);
              data.accountId = result;
              accounts.add(data);
              Get.back();
            },
          )
        ]);
  }

  void showDialogUpdateAccount(AccountModel model) async {
    TextEditingController controller = TextEditingController();
    controller.text = model.accountName ?? '';
    DialogUtil.showDialog(
        title: 'Cập nhật tài khoản',
        content: InputWidget(
          hintText: 'Nhập tên tài khoản',
          controller: controller,
        ),
        actions: [
          ActionDialog(
            text: 'Xóa',
            onPressed: () async {
              int result = await _sqlService.deleteAccount(model);
              if (result == -1) {
                DialogUtil.showDialogError(text: 'Tài khoản đã được sử dụng');
                return;
              } else if (result == 1) {
                accounts.remove(model);
              }
              Get.back();
            },
          ),
          ActionDialog(
            text: 'Cập nhật',
            onPressed: () async {
              model.accountName = controller.text;
              int result = await _sqlService.updateAccount(model);
              print('result $result');
              if (result == 1) {
                accounts.refresh();
              }
              Get.back();
            },
          )
        ]);
  }

  void showBottomCategory() async {
    DialogUtil.showBottomSheet(
        'Chọn thể loại',
        Column(
          children: [
            Obx(() => TabWidget(
                  currentStep: type.value,
                  steps: [
                    MyStep(title: 'Khoản chi', isActive: type.value == 0),
                    MyStep(title: 'Khoản thu', isActive: type.value == 1)
                  ],
                  onStepTapped: (value) {
                    type.value = value;
                  },
                )),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: Obx(() => GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 4.0,
                            crossAxisSpacing: 4.0,
                            childAspectRatio: 1.8),
                    itemBuilder: (context, index) {
                      int length = (type.value == 0)
                          ? categoriesChi.length
                          : categoriesThu.length;
                      if (index < length) {
                        return GestureDetector(
                          onLongPress: () {
                            if (type.value == 0) {
                              showDialogUpdateCategory(categoriesChi[index]);
                            } else {
                              showDialogUpdateCategory(categoriesThu[index]);
                            }
                          },
                          onTap: () {
                            if (type.value == 0) {
                              categorySelected.value = categoriesChi[index];
                            } else {
                              categorySelected.value = categoriesThu[index];
                            }
                            Get.back();
                          },
                          child: Card(
                            child: Container(
                              padding: const EdgeInsets.all(4.0),
                              color: Colors.white,
                              child: Center(
                                child: TextWidget(
                                  text: (type.value == 0)
                                      ? categoriesChi[index].categoryName ?? ''
                                      : categoriesThu[index].categoryName ?? '',
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        );
                      } else {
                        return GestureDetector(
                          onTap: () async {
                            showDialogNewCategory();
                          },
                          child: Card(
                            child: Container(
                              padding: const EdgeInsets.all(4.0),
                              color: Colors.white,
                              child: const Center(
                                child: TextWidget(
                                  text: '+',
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                    },
                    itemCount: (type.value == 0)
                        ? categoriesChi.length + 1
                        : categoriesThu.length + 1,
                  )),
            ),
          ],
        ),
        backgroundColor: AppColors.backgroundColor);
  }

  void showDialogNewCategory() async {
    TextEditingController controller = TextEditingController();
    DialogUtil.showDialog(
        title: 'Thêm thể loại',
        content: InputWidget(
          hintText: 'Nhập tên thể loại',
          controller: controller,
        ),
        actions: [
          ActionDialog(
            text: 'HỦY',
            onPressed: () {
              Get.back();
            },
          ),
          ActionDialog(
            text: 'OK',
            onPressed: () async {
              CategoryModel data = CategoryModel();
              data.categoryName = controller.text;
              data.categoryTypeId = (type.value == 0) ? 2 : 1;
              int result = await _sqlService.newCategory(data);
              data.categoryId = result;
              if (type.value == 0) {
                categoriesChi.add(data);
              } else {
                categoriesThu.add(data);
              }
              Get.back();
            },
          )
        ]);
  }

  void showDialogUpdateCategory(CategoryModel model) async {
    TextEditingController controller = TextEditingController();
    controller.text = model.categoryName ?? '';
    DialogUtil.showDialog(
        title: 'Cập nhật thể loại',
        content: InputWidget(
          hintText: 'Nhập tên thể loại',
          controller: controller,
        ),
        actions: [
          ActionDialog(
            text: 'Xóa',
            onPressed: () async {
              int result = await _sqlService.deleteCategory(model);
              if (result == -1) {
                DialogUtil.showDialogError(
                    text: 'Thể loại đã được sử dụng, không thể xóa');
                return;
              } else if (result == 1) {
                accounts.remove(model);
              }
              Get.back();
            },
          ),
          ActionDialog(
            text: 'Cập nhật',
            onPressed: () async {
              model.categoryName = controller.text;
              int result = await _sqlService.updateCategory(model);
              if (result == 1) {
                if (type.value == 0) {
                  categoriesChi.refresh();
                } else {
                  categoriesThu.refresh();
                }
              }
              Get.back();
            },
          )
        ]);
  }
}
