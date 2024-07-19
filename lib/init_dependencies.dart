import 'package:fasting_app/features/fasting/data/data_source/fasting_local_data_source.dart';
import 'package:fasting_app/features/fasting/data/models/fast_model.dart';
import 'package:fasting_app/features/fasting/data/repository/fasting_repository_impl.dart';
import 'package:fasting_app/features/fasting/domain/repository/fasting_repository.dart';
import 'package:fasting_app/features/fasting/domain/use%20cases/delete_fast.dart';
import 'package:fasting_app/features/fasting/domain/use%20cases/get_all_fasts.dart';
import 'package:fasting_app/features/fasting/domain/use%20cases/get_fast_on_date.dart';
import 'package:fasting_app/features/fasting/domain/use%20cases/get_last_fast.dart';
import 'package:fasting_app/features/fasting/domain/use%20cases/reset_data.dart';
import 'package:fasting_app/features/fasting/domain/use%20cases/save_fast.dart';
import 'package:fasting_app/features/fasting/domain/use%20cases/update_fast.dart';
import 'package:fasting_app/features/fasting/presentation/bloc/fasting_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

final serviceLocator = GetIt.instance;

Future initDependencies() async {
  final dir = await getApplicationDocumentsDirectory();
  final isarInstance = await Isar.open([FastModelSchema], directory: dir.path);
  final sharedPreferenceInstance = await SharedPreferences.getInstance();
  final deviceInfo = await PackageInfo.fromPlatform();

  await notificationsInit();

  serviceLocator.registerLazySingleton(() => isarInstance);
  serviceLocator.registerLazySingleton(() => deviceInfo);
  serviceLocator.registerLazySingleton(() => sharedPreferenceInstance);

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
    ..registerFactory(() => UseCaseGetAllFasts(serviceLocator()))
    ..registerFactory(() => UseCaseDeleteFast(serviceLocator()))
    ..registerFactory(() => UseCaseResetData(serviceLocator()))
    ..registerLazySingleton<FastingBloc>(() => FastingBloc(
          usecaseDeleteFast: serviceLocator(),
          useCaseGetFastOnDate: serviceLocator(),
          useCaseResetData: serviceLocator(),
          useCaseSaveFast: serviceLocator(),
          useCaseGetAllFasts: serviceLocator(),
          useCaseUpdateFast: serviceLocator(),
          useCaseGetLastFast: serviceLocator(),
        ));
}

Future notificationsInit() async {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  var initializationSettingsAndroid =
      const AndroidInitializationSettings('launcher_icon');
  var initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  flutterLocalNotificationsPlugin.initialize(initializationSettings);

  serviceLocator.registerLazySingleton<FlutterLocalNotificationsPlugin>(
      () => flutterLocalNotificationsPlugin);
}
