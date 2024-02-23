import 'package:money_saver/services/constants.dart';

class AccountModel {
  int? accountId;
  String? accountName;
  String? accountNote;
  int? accountMoney;

  AccountModel(
      {this.accountId, this.accountName, this.accountNote, this.accountMoney});

  factory AccountModel.fromMap(Map<String, dynamic> data) {
    return AccountModel(
        accountId: data[Constants.accountId],
        accountName: data[Constants.accountName],
        accountNote: data[Constants.accountNote],
        accountMoney: data[Constants.accountMoney] ?? 0);
  }

  Map<String, dynamic> toMap() {
    return {
      Constants.accountId: accountId,
      Constants.accountName: accountName,
      Constants.accountNote: accountNote,
      Constants.accountMoney: accountMoney ?? 0
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AccountModel &&
          runtimeType == other.runtimeType &&
          accountId == other.accountId;

  @override
  int get hashCode => accountId.hashCode;
}
