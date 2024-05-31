import 'package:fasting_app/core/entities/time_ration_entity.dart';
import 'package:fasting_app/core/enums/fast_status.dart';
import 'package:fasting_app/core/entities/fast_entity.dart';
import 'package:isar/isar.dart';

part 'fast_model.g.dart';

@collection
class FastModel extends FastEntity {
  FastModel({
    super.isarId,
    super.startTime,
    super.durationInMilliseconds,
    super.savedOn,
    super.fastingTimeRatio,
    super.completedDurationInMilliseconds,
    super.endTime,
    super.status,
    super.note,
    super.rating,
  });

  factory FastModel.fromJson(Map<String, dynamic> json) {
    return FastModel(
      isarId: json['isarId'],
      startTime: json['startTime'] ?? DateTime.now(),
      savedOn: json['savedOn'] ?? DateTime.now(),
      completedDurationInMilliseconds:
          json['completedDurationInMilliseconds'] ?? DateTime.now(),
      fastingTimeRatio:
          json['fastingTimeRatio'] ?? FastingTimeRatioEntity(fast: 13, eat: 11),
      durationInMilliseconds:
          json['durationInMilliseconds'] ?? const Duration().inMilliseconds,
      endTime:
          json['endTime'] ?? DateTime.now().add(const Duration(seconds: 1)),
      note: json['note'] ?? '',
      status: json['status'] ?? FastStatus.finished,
      rating: json['rating'] ?? 0,
    );
  }

  Map<String, dynamic> toJson(FastModel fastModel) {
    return {
      'isarId': fastModel.isarId,
      'startTime': fastModel.startTime,
      'savedOn': fastModel.savedOn,
      'completedDurationInMilliseconds':
          fastModel.completedDurationInMilliseconds,
      'durationInMilliseconds': fastModel.durationInMilliseconds,
      'endTime': fastModel.endTime,
      'fastingTimeRatio': fastModel.fastingTimeRatio,
      'note': fastModel.note,
      'status': fastModel.status,
      'rating': fastModel.rating,
    };
  }

  FastModel copyWith(FastModel fastModel) {
    return FastModel(
      isarId: isarId,
      startTime: fastModel.startTime ?? startTime,
      completedDurationInMilliseconds:
          fastModel.completedDurationInMilliseconds ??
              completedDurationInMilliseconds,
      durationInMilliseconds:
          fastModel.durationInMilliseconds ?? durationInMilliseconds,
      endTime: fastModel.endTime ?? endTime,
      savedOn: fastModel.savedOn ?? savedOn,
      fastingTimeRatio: fastModel.fastingTimeRatio ?? fastingTimeRatio,
      note: fastModel.note ?? note,
      status: fastModel.status,
      rating: fastModel.rating ?? rating,
    );
  }
}
