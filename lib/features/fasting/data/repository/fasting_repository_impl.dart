import 'dart:developer';

import 'package:fasting_app/core/entities/fast_entity.dart';
import 'package:fasting_app/core/entities/time_ration_entity.dart';
import 'package:fasting_app/core/enums/fast_status.dart';
import 'package:fasting_app/core/error/kfailure.dart';
import 'package:fasting_app/core/error/kserver_exception.dart';
import 'package:fasting_app/features/fasting/data/data_source/fasting_local_data_source.dart';
import 'package:fasting_app/features/fasting/data/models/fast_model.dart';
import 'package:fasting_app/features/fasting/domain/repository/fasting_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:isar/isar.dart';

class FastingRepositoryImpl implements FastingRepository {
  final FastingLocalDataSource fastingLocalDataSource;

  FastingRepositoryImpl(this.fastingLocalDataSource);

  @override
  Future<Either<KFailure, void>> saveFast({
    required DateTime startTime,
    required int durationInMilliseconds,
    required FastStatus status,
    required FastingTimeRatioEntity fastingTimeRatio,
  }) async {
    try {
      await fastingLocalDataSource.addFast(
          fastModel: FastModel(
        startTime: startTime,
        durationInMilliseconds: durationInMilliseconds,
        fastingTimeRatio: fastingTimeRatio,
        status: status,
      ));
      return right(null);
    } on KServerException catch (e) {
      return left(KFailure(e.error));
    }
  }

  @override
  Future<Either<KFailure, List<FastModel>>> getFastsByDate(
      {required DateTime savedOn}) async {
    try {
      final response =
          await fastingLocalDataSource.getFastsByDate(savedData: savedOn);
      return right(response);
    } on KServerException catch (e) {
      return left(KFailure(e.error));
    }
  }

  @override
  Future<Either<KFailure, FastModel?>> getLastFast() async {
    try {
      final response = await fastingLocalDataSource.getLastFast();
      return right(response);
    } on KServerException catch (e) {
      return left(KFailure(e.error));
    }
  }

  @override
  Future<Either<KFailure, void>> updateFast({
    required Id isarId,
    DateTime? startTime,
    int? durationInMilliseconds,
    DateTime? savedOn,
    FastingTimeRatioEntity? fastingTimeRation,
    DateTime? endTime,
    required FastStatus status,
    int? completedDurationInMilliseconds,
    String? note,
    int? rating,
  }) async {
    try {
      await fastingLocalDataSource.addFast(
          fastModel: FastModel(
        durationInMilliseconds: durationInMilliseconds,
        completedDurationInMilliseconds: completedDurationInMilliseconds,
        endTime: endTime,
        fastingTimeRatio: fastingTimeRation,
        isarId: isarId,
        note: note,
        rating: rating,
        savedOn: savedOn,
        startTime: startTime,
        status: status,
      ));
      return right(null);
    } on KServerException catch (e) {
      return left(KFailure(e.error));
    }
  }
}
