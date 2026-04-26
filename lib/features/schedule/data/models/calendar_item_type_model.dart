import 'package:masr_al_qsariya/features/schedule/domain/entities/calendar_item_type.dart';

class CalendarItemTypeModel {
  const CalendarItemTypeModel({
    required this.value,
    required this.label,
    required this.categoryId,
  });

  final String value;
  final String label;
  final int? categoryId;

  factory CalendarItemTypeModel.fromJson(Map<String, dynamic> json) {
    return CalendarItemTypeModel(
      value: (json['value'] as String?) ?? '',
      label: (json['label'] as String?) ?? '',
      categoryId: (json['category_id'] as num?)?.toInt(),
    );
  }

  CalendarItemTypeEntity toEntity() => CalendarItemTypeEntity(
        value: value,
        label: label,
        categoryId: categoryId,
      );
}

