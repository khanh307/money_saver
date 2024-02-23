import 'package:money_saver/services/constants.dart';

class LogsModel {
  int? logId;
  int? money;
  int? categoryId;
  int? accountId;
  String? note;
  DateTime? dateCreated;
  DateTime? dateModified;

  LogsModel(
      {this.logId,
      this.money,
      this.categoryId,
      this.accountId,
      this.note,
      this.dateCreated,
      this.dateModified});

  factory LogsModel.fromMap(Map<String, dynamic> data) {
    return LogsModel(
        logId: data[Constants.logId],
        money: data[Constants.money],
        categoryId: data[Constants.categoryId],
        accountId: data[Constants.accountId],
        note: data[Constants.note],
        dateCreated: data[Constants.dateCreated],
        dateModified: data[Constants.dateModified]);
  }

  Map<String, dynamic> toMap() {
    return {
      Constants.logId: logId,
      Constants.money: money,
      Constants.categoryId: categoryId,
      Constants.accountId: accountId,
      Constants.note: note,
      Constants.dateCreated: dateCreated!.toIso8601String(),
      Constants.dateModified:
          (dateModified == null) ? null : dateModified!.toIso8601String()
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LogsModel &&
          runtimeType == other.runtimeType &&
          logId == other.logId;

  @override
  int get hashCode => logId.hashCode;
}
