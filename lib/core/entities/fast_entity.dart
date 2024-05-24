import 'package:fasting_app/core/entities/time_ration_entity.dart';
import 'package:fasting_app/core/enums/fast_status.dart';
import 'package:isar/isar.dart';

class FastEntity {
  Id? isarId;
  final DateTime? startTime;
  final int? durationInMilliseconds;
  final DateTime? endTime;
  final int? completedDurationInMilliseconds;
  @enumerated
  final FastStatus status;
  final FastingTimeRatioEntity? fastingTimeRatio;
  final DateTime? savedOn;
  final int? rating;
  final String? note;

  FastEntity(
      {this.isarId,
      this.startTime,
      this.durationInMilliseconds,
      this.status = FastStatus.finished,
      this.savedOn,
      this.fastingTimeRatio,
      this.completedDurationInMilliseconds,
      this.note,
      this.endTime,
      this.rating});

  @override
  String toString() {
    return 'FastEntity{'
        'isarId: $isarId, '
        'startTime: ${startTime?.toIso8601String() ?? 'null'}, '
        'durationInMilliseconds: $durationInMilliseconds, '
        'completedDurationInMilliseconds: $completedDurationInMilliseconds, '
        'endTime: ${endTime?.toIso8601String() ?? 'null'}, '
        'status: $status, '
        'fastingTimeRatio: $fastingTimeRatio, '
        'savedOn: ${savedOn?.toIso8601String() ?? 'null'}, '
        'rating: $rating, '
        'note: $note'
        '}';
  }
}
