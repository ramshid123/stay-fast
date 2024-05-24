import 'package:fasting_app/features/fasting/data/data_source/fasting_local_data_source.dart';
import 'package:fasting_app/features/fasting/data/models/fast_model.dart';
import 'package:fasting_app/features/fasting/data/repository/fasting_repository_impl.dart';
import 'package:fasting_app/features/fasting/domain/repository/fasting_repository.dart';
import 'package:fasting_app/features/fasting/domain/use%20cases/get_fast_on_date.dart';
import 'package:fasting_app/features/fasting/domain/use%20cases/get_last_fast.dart';
import 'package:fasting_app/features/fasting/domain/use%20cases/save_fast.dart';
import 'package:fasting_app/features/fasting/domain/use%20cases/update_fast.dart';
import 'package:fasting_app/features/fasting/presentation/bloc/fasting_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

final serviceLocator = GetIt.instance;

Future initDependencies() async {
  final dir = await getApplicationDocumentsDirectory();
  final isarInstance = await Isar.open([FastModelSchema], directory: dir.path);

  serviceLocator.registerLazySingleton(() => isarInstance);

  _initFasting();
}

void _initFasting() {
  serviceLocator
    ..registerFactory<FastingLocalDataSource>(
        () => FastingLocalDataSourceImpl(serviceLocator()))
    ..registerFactory<FastingRepository>(
        () => FastingRepositoryImpl(serviceLocator()))
    ..registerFactory(() => UseCaseSaveFast(serviceLocator()))
    ..registerFactory(() => UseCaseGetLastFast(serviceLocator()))
    ..registerFactory(() => UseCaseUpdateFast(serviceLocator()))
    ..registerFactory(() => UseCaseGetFastOnDate(serviceLocator()))
    ..registerLazySingleton<FastingBloc>(() => FastingBloc(
          useCaseGetFastOnDate: serviceLocator(),
          useCaseSaveFast: serviceLocator(),
          useCaseUpdateFast: serviceLocator(),
          useCaseGetLastFast: serviceLocator(),
        ));
}
