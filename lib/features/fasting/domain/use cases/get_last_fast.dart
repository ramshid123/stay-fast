import 'package:fasting_app/core/error/kfailure.dart';
import 'package:fasting_app/core/usecase/use_case.dart';
import 'package:fasting_app/core/entities/fast_entity.dart';
import 'package:fasting_app/features/fasting/domain/repository/fasting_repository.dart';
import 'package:fpdart/fpdart.dart';

class UseCaseGetLastFast implements UseCase<FastEntity?, NoParams> {
  final FastingRepository fastingRepository;

  UseCaseGetLastFast(this.fastingRepository);

  @override
  Future<Either<KFailure, FastEntity?>> call(NoParams params) async {
    return await fastingRepository.getLastFast();
  }
}
