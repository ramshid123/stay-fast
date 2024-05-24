import 'package:fasting_app/core/entities/fast_entity.dart';
import 'package:fasting_app/core/error/kfailure.dart';
import 'package:fasting_app/core/usecase/use_case.dart';
import 'package:fasting_app/features/fasting/domain/repository/fasting_repository.dart';
import 'package:fpdart/fpdart.dart';

class UseCaseGetFastOnDate
    implements UseCase<List<FastEntity>, UseCaseGetFastOnDateParams> {
  final FastingRepository fastingRepository;

  UseCaseGetFastOnDate(this.fastingRepository);

  @override
  Future<Either<KFailure, List<FastEntity>>> call(
      UseCaseGetFastOnDateParams params) async {
    return await fastingRepository.getFastsByDate(savedOn: params.savedOn);
  }
}

class UseCaseGetFastOnDateParams {
  final DateTime savedOn;

  UseCaseGetFastOnDateParams(this.savedOn);
}
