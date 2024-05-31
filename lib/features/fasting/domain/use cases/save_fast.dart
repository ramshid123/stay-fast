import 'package:fasting_app/core/entities/time_ration_entity.dart';
import 'package:fasting_app/core/enums/fast_status.dart';
import 'package:fasting_app/core/error/kfailure.dart';
import 'package:fasting_app/core/usecase/use_case.dart';
import 'package:fasting_app/features/fasting/domain/repository/fasting_repository.dart';
import 'package:fpdart/fpdart.dart';

class UseCaseSaveFast implements UseCase<void, UseCaseSaveFastParams> {
  final FastingRepository fastingRepository;

  UseCaseSaveFast(this.fastingRepository);

  @override
  Future<Either<KFailure, void>> call(UseCaseSaveFastParams params) async {
    return await fastingRepository.saveFast(
        startTime: params.startTime,
        durationInMilliseconds: params.durationInMilliseconds,
        fastingTimeRatio: params.fastingTimeRatio,
        status: params.status);
  }
}

class UseCaseSaveFastParams {
  final DateTime startTime;
  final int durationInMilliseconds;
  final FastStatus status;
  final FastingTimeRatioEntity fastingTimeRatio;

  UseCaseSaveFastParams(
      {required this.startTime,
      required this.durationInMilliseconds,
      required this.fastingTimeRatio,
      required this.status});
}
