import 'package:fasting_app/core/enums/fast_status.dart';
import 'package:fasting_app/core/error/kserver_exception.dart';
import 'package:fasting_app/features/fasting/data/models/fast_model.dart';
import 'package:isar/isar.dart';

abstract interface class FastingLocalDataSource {
  Future addFast({required FastModel fastModel});

  Future<List<FastModel>> getFastsByDate({required DateTime savedData});

  Future<FastModel?> getLastFast();

  Future<List<FastModel>> getAllFasts();

  Future deleteFast(int id);

  Future resetData();
}

class FastingLocalDataSourceImpl implements FastingLocalDataSource {
  final Isar isarInstance;

  FastingLocalDataSourceImpl(this.isarInstance);

  @override
  Future addFast({required FastModel fastModel}) async {
    try {
      await isarInstance.writeTxn(() async {
        await isarInstance.fastModels.put(fastModel);
      });
    } catch (e) {
      throw KServerException(e.toString());
    }
  }

  @override
  Future<List<FastModel>> getFastsByDate({required DateTime savedData}) async {
    try {
      final fastModels = await isarInstance.fastModels
          .filter()
          .savedOnEqualTo(savedData)
          .statusEqualTo(FastStatus.finished)
          .findAll();

      return fastModels;
    } catch (e) {
      throw (KServerException(e.toString()));
    }
  }

  @override
  Future<FastModel?> getLastFast() async {
    try {
      return await isarInstance.fastModels
          .where()
          .sortByStartTimeDesc()
          .limit(1)
          .findFirst();
    } catch (e) {
      throw KServerException(e.toString());
    }
  }

  @override
  Future<List<FastModel>> getAllFasts() async {
    try {
      return await isarInstance.fastModels
          .filter()
          .statusEqualTo(FastStatus.finished)
          .findAll();
    } catch (e) {
      throw KServerException(e.toString());
    }
  }

  @override
  Future deleteFast(int id) async {
    try {
      await isarInstance.writeTxn(() async {
        await isarInstance.fastModels.delete(id);
      });
    } catch (e) {
      throw KServerException(e.toString());
    }
  }

  @override
  Future resetData() async {
    try {
      await isarInstance.writeTxn(() async {
        await isarInstance.clear();
      });
    } catch (e) {
      throw KServerException(e.toString());
    }
  }
}
