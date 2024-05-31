import 'package:fasting_app/core/entities/time_ration_entity.dart';
import 'package:fasting_app/core/enums/fast_status.dart';
import 'package:fasting_app/core/error/kfailure.dart';
import 'package:fasting_app/core/usecase/use_case.dart';
import 'package:fasting_app/features/fasting/domain/repository/fasting_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:isar/isar.dart';

class UseCaseUpdateFast implements UseCase<void, UseCaseUpdateFastParams> {
  final FastingRepository fastingRepository;

  UseCaseUpdateFast(this.fastingRepository);

  @override
  Future<Either<KFailure, void>> call(UseCaseUpdateFastParams params) async {
    return await fastingRepository.updateFast(
      isarId: params.isarId,
      status: params.status,
      durationInMilliseconds: params.durationInMilliseconds,
      endTime: params.endTime,
      fastingTimeRation: params.fastingTimeRation,
      completedDurationInMilliseconds: params.completedDurationInMilliseconds,
      note: params.note,
      rating: params.rating,
      savedOn: params.savedOn,
      startTime: params.startTime,
    );
  }
}

class UseCaseUpdateFastParams {
  Id isarId;
  DateTime? startTime;
  int? durationInMilliseconds;
  DateTime? savedOn;
  FastingTimeRatioEntity? fastingTimeRation;
  int? completedDurationInMilliseconds;
  DateTime? endTime;
  FastStatus status;
  String? note;
  int? rating;

  UseCaseUpdateFastParams({
    required this.isarId,
    this.startTime,
    this.durationInMilliseconds,
    this.savedOn,
    this.completedDurationInMilliseconds,
    this.fastingTimeRation,
    this.endTime,
    required this.status,
    this.note,
    this.rating,
  });
}
