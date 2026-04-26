import 'package:equatable/equatable.dart';

class CalendarItemTypeEntity extends Equatable {
  const CalendarItemTypeEntity({
    required this.value,
    required this.label,
    required this.categoryId,
  });

  final String value;
  final String label;
  final int? categoryId;

  bool get isCall => value == 'audio_call' || value == 'video_call';

  @override
  List<Object?> get props => [value, label, categoryId];
}

