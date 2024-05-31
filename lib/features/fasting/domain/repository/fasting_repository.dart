import 'package:fasting_app/core/entities/time_ration_entity.dart';
import 'package:fasting_app/core/enums/fast_status.dart';
import 'package:fasting_app/core/error/kfailure.dart';
import 'package:fasting_app/core/entities/fast_entity.dart';
import 'package:fpdart/fpdart.dart';
import 'package:isar/isar.dart';

abstract interface class FastingRepository {
  Future<Either<KFailure, void>> saveFast({
    required DateTime startTime,
    required int durationInMilliseconds,
    required FastStatus status,
    required FastingTimeRatioEntity fastingTimeRatio,
  });

  Future<Either<KFailure, List<FastEntity>>> getFastsByDate(
      {required DateTime savedOn});

  Future<Either<KFailure, FastEntity?>> getLastFast();

  Future<Either<KFailure, void>> updateFast({
    required Id isarId,
    DateTime? startTime,
    int? durationInMilliseconds,
    DateTime? savedOn,
    FastingTimeRatioEntity? fastingTimeRation,
    int? completedDurationInMilliseconds,
    DateTime? endTime,
    required FastStatus status,
    String? note,
    int? rating,
  });

  Future<Either<KFailure, List<FastEntity>>> getAllFastsDetails();
}
