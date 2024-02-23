import 'package:money_saver/services/constants.dart';

class CategoryModel {
  int? categoryId;
  String? categoryName;
  int? categoryTypeId;

  CategoryModel({this.categoryId, this.categoryName, this.categoryTypeId});

  factory CategoryModel.fromMap(Map<String, dynamic> data) {
    return CategoryModel(
      categoryId: data[Constants.categoryId],
      categoryName: data[Constants.categoryName],
      categoryTypeId: data[Constants.categoryTypeId]
    );
  }

  Map<String, dynamic> toMap() {
    return {
      Constants.categoryId: categoryId,
      Constants.categoryName: categoryName,
      Constants.categoryTypeId: categoryTypeId
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryModel &&
          runtimeType == other.runtimeType &&
          categoryId == other.categoryId;

  @override
  int get hashCode => categoryId.hashCode;
}
