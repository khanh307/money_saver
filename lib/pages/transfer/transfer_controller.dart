import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:money_saver/models/account_model.dart';
import 'package:money_saver/pages/home/home_controller.dart';
import 'package:money_saver/pages/transfer/transfer_sql_service.dart';
import 'package:money_saver/utils/const/app_colors.dart';
import 'package:money_saver/utils/dialog_util.dart';
import 'package:money_saver/utils/text_field_format/currency_text_format.dart';
import 'package:money_saver/widgets/input_widget.dart';
import 'package:money_saver/widgets/text_widget.dart';

class TransferController extends GetxController {
  static TransferController get instants => Get.find();
  final TransferSqlService _sqlService = TransferSqlService();
  Rx<AccountModel?> fromAccountSelected = Rx(null);
  Rx<AccountModel?> toAccountSelected = Rx(null);
  RxList<AccountModel> accounts = <AccountModel>[].obs;
  FocusNode moneyFocusNode = FocusNode();
  TextEditingController moneyController = TextEditingController();

  @override
  void onReady() async {
    await DialogUtil.showLoading();
    await getAccounts();
    DialogUtil.hideLoading();
    super.onReady();
  }

  Future getAccounts() async {
    accounts.clear();
    final data = await _sqlService.getAccounts();
    accounts.addAll(data);
  }

  Future transfer() async {
    if (fromAccountSelected.value == null) {
      DialogUtil.showDialogWarning(text: 'Vui lòng chọn tài khoản chuyển');
      return;
    }
    if (toAccountSelected.value == null) {
      DialogUtil.showDialogWarning(text: 'Vui lòng chọn tài khoản nhận');
      return;
    }
    if (moneyController.text.isEmpty) {
      DialogUtil.showDialogWarning(text: 'Vui lòng nhập số tiền');
      return;
    }

    int money = int.parse(moneyController.text.replaceAll('.', ''));
    if (fromAccountSelected.value!.accountMoney! < money) {
      DialogUtil.showDialogWarning(text: 'Tài khoản không đủ số dư');
      return;
    }
    await DialogUtil.showLoading();
    bool status = await _sqlService.transfer(fromAccountSelected.value!, toAccountSelected.value!, money);
    DialogUtil.hideLoading();
    if (status) {
      DialogUtil.showDialogSuccess(text: 'Chuyển thành công', action: () {
        HomeController.instants.reloadData();
        fromAccountSelected.value = null;
        toAccountSelected.value = null;
        moneyController.clear();
      },);
    } else {
      DialogUtil.showDialogError(text: 'Chuyển tiền thất bại');
    }
  }

  void showBottomAccount({bool isFrom = true}) async {
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
                      if (isFrom) {
                        fromAccountSelected.value = accounts[index];
                      } else {
                        toAccountSelected.value = accounts[index];
                      }

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
    TextEditingController moneyAccountController =
        TextEditingController(text: '0');
    DialogUtil.showDialog(
        title: 'Thêm tài khoản',
        content: Column(
          children: [
            InputWidget(
              hintText: 'Nhập tên tài khoản',
              controller: controller,
            ),
            const SizedBox(
              height: 10,
            ),
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
              data.accountMoney =
                  int.parse(moneyAccountController.text.replaceAll('.', ''));
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
}
