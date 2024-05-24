import 'package:fasting_app/core/error/kfailure.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class UseCase<SuccessType, Params> {
  Future<Either<KFailure, SuccessType>> call(Params params);
}

class NoParams {
  const NoParams();
}
