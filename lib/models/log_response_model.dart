import 'package:money_saver/models/account_model.dart';
import 'package:money_saver/models/category_model.dart';
import 'package:money_saver/services/constants.dart';

class LogsResponseModel {
  int? logId;
  int? money;
  CategoryModel? category;
  AccountModel? account;
  String? note;
  DateTime? dateCreated;
  DateTime? dateModified;
  int? type;

  LogsResponseModel(
      {this.logId,
      this.money,
      this.category,
      this.account,
      this.note,
      this.dateCreated,
        this.type,
      this.dateModified});

  factory LogsResponseModel.fromMap(Map<String, dynamic> data) {
    return LogsResponseModel(
        logId: data[Constants.logId],
        money: data[Constants.money],
        category: CategoryModel.fromMap(data),
        account: AccountModel.fromMap(data),
        note: data[Constants.note],
        type: data[Constants.categoryTypeId],
        dateCreated: DateTime.parse(data[Constants.dateCreated]),
        dateModified: (data[Constants.dateModified] == null)
            ? null
            : DateTime.parse(data[Constants.dateModified]));
  }

  Map<String, dynamic> toMap() {
    return {
      Constants.logId: logId,
      Constants.money: money,
      Constants.categoryId: category,
      Constants.accountId: account,
      Constants.note: note,
      Constants.dateCreated: dateCreated!.toIso8601String(),
      Constants.dateModified:
          (dateModified == null) ? null : dateModified!.toIso8601String()
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LogsResponseModel &&
          runtimeType == other.runtimeType &&
          logId == other.logId;

  @override
  int get hashCode => logId.hashCode;
}
