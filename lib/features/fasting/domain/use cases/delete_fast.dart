import 'package:fasting_app/core/error/kfailure.dart';
import 'package:fasting_app/core/usecase/use_case.dart';
import 'package:fasting_app/features/fasting/domain/repository/fasting_repository.dart';
import 'package:fpdart/fpdart.dart';

class UseCaseDeleteFast implements UseCase<void, UseCaseDeleteFastParams> {
  final FastingRepository fastingRepository;

  UseCaseDeleteFast(this.fastingRepository);
  @override
  Future<Either<KFailure, void>> call(UseCaseDeleteFastParams params) async {
    return await fastingRepository.deleteFast(params.id);
  }
}

class UseCaseDeleteFastParams {
  final int id;

  UseCaseDeleteFastParams(this.id);
}
