import 'package:fasting_app/core/error/kfailure.dart';
import 'package:fasting_app/core/usecase/use_case.dart';
import 'package:fasting_app/features/fasting/domain/repository/fasting_repository.dart';
import 'package:fpdart/fpdart.dart';

class UseCaseResetData implements UseCase<void, UseCaseResetDataParams> {
  final FastingRepository fastingRepository;

  UseCaseResetData(this.fastingRepository);

  @override
  Future<Either<KFailure, void>> call(UseCaseResetDataParams params) async {
    return await fastingRepository.resetData();
  }
}

class UseCaseResetDataParams {}
