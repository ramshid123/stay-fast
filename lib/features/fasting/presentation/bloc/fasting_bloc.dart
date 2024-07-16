import 'dart:developer';

import 'package:fasting_app/core/entities/time_ration_entity.dart';
import 'package:fasting_app/core/usecase/use_case.dart';
import 'package:fasting_app/core/entities/fast_entity.dart';
import 'package:fasting_app/features/fasting/domain/use%20cases/delete_fast.dart';
import 'package:fasting_app/features/fasting/domain/use%20cases/get_all_fasts.dart';
import 'package:fasting_app/features/fasting/domain/use%20cases/get_fast_on_date.dart';
import 'package:fasting_app/features/fasting/domain/use%20cases/get_last_fast.dart';
import 'package:fasting_app/features/fasting/domain/use%20cases/reset_data.dart';
import 'package:fasting_app/features/fasting/domain/use%20cases/update_fast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fasting_app/core/enums/fast_status.dart';
import 'package:fasting_app/features/fasting/domain/use%20cases/save_fast.dart';

part 'fasting_event.dart';
part 'fasting_state.dart';

class FastingBloc extends Bloc<FastingEvent, FastingState> {
  final UseCaseSaveFast _useCaseSaveFast;
  final UseCaseGetLastFast _useCaseGetLastFast;
  final UseCaseUpdateFast _useCaseUpdateFast;
  final UseCaseGetFastOnDate _useCaseGetFastOnDate;
  final UseCaseGetAllFasts _useCaseGetAllFasts;
  final UseCaseDeleteFast _useCaseDeleteFast;
  final UseCaseResetData _useCaseResetData;

  FastingBloc({
    required UseCaseSaveFast useCaseSaveFast,
    required UseCaseGetLastFast useCaseGetLastFast,
    required UseCaseUpdateFast useCaseUpdateFast,
    required UseCaseGetFastOnDate useCaseGetFastOnDate,
    required UseCaseGetAllFasts useCaseGetAllFasts,
    required UseCaseResetData useCaseResetData,
    required UseCaseDeleteFast usecaseDeleteFast,
  })  : _useCaseSaveFast = useCaseSaveFast,
        _useCaseGetLastFast = useCaseGetLastFast,
        _useCaseUpdateFast = useCaseUpdateFast,
        _useCaseGetFastOnDate = useCaseGetFastOnDate,
        _useCaseGetAllFasts = useCaseGetAllFasts,
        _useCaseDeleteFast = usecaseDeleteFast,
        _useCaseResetData = useCaseResetData,
        super(FastingStateInitial()) {
    on<FastingEventCheckFast>(
        (event, emit) async => await _onFastingCheckFast(event, emit));
    on<FastingEventSaveFast>(
        (event, emit) async => await _onFastingEventSaveFast(event, emit));

    on<FastingEventChangeFastPeriod>(
        (event, emit) => _onFastingEventChangeFastPeriod(event, emit));

    on<FastingEventUpdateFast>(
        (event, emit) async => await _onFastingEventUpdateFast(event, emit));

    on<FastingEventSelectJournalDate>(
        (event, emit) => _onFastingEventSelectJournalDate(event, emit));

    on<FastingEventGetAllFasts>(
        (event, emit) async => await _onFastingEventGetAllFasts(event, emit));

    on<FastingEventDeleteFast>(
        (event, emit) async => await _onFastingEventDeleteFast(event, emit));

    on<FastingEventResetData>(
        (event, emit) async => await _onFastingEventResetData(event, emit));
  }

  Future _onFastingEventGetAllFasts(
      FastingEventGetAllFasts event, Emitter<FastingState> emit) async {
    final res = await _useCaseGetAllFasts(const NoParams());

    res.fold(
      (l) => emit(FastingStateFailure(l.message)),
      (r) {
        int fastingDurationInMilliseconds = 0;
        int longestFast = 0;

        DateTime date = DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().year);
        int daysWithFast = 0;

        for (var fast in r) {
          fastingDurationInMilliseconds +=
              fast.completedDurationInMilliseconds ?? 0;
          if ((fast.completedDurationInMilliseconds ?? 0) > longestFast) {
            longestFast = fast.completedDurationInMilliseconds ?? longestFast;
          }

          if (date != fast.savedOn) {
            daysWithFast++;
          }
          date = fast.savedOn!;
        }
        // final totalFastingHours =
        //     Duration(milliseconds: fastingDurationInMilliseconds)
        //         .inHours; /

        final totalFastNo = r.length;

        emit(FastingStateAllFasts(
          totalFasts: totalFastNo,
          longestFast: longestFast,
          daysWithFast: daysWithFast,
          totalFastingHours: fastingDurationInMilliseconds,
          fastList: r,
        ));
      },
    );
  }

  Future _onFastingEventResetData(
      FastingEventResetData event, Emitter<FastingState> emit) async {
    final response = await _useCaseResetData(UseCaseResetDataParams());

    response.fold(
      (l) => emit(FastingStateFailure(l.message)),
      (r) => emit(FastingStateRestartApp()),
    );
  }

  Future _onFastingEventDeleteFast(
      FastingEventDeleteFast event, Emitter<FastingState> emit) async {
    final res = await _useCaseDeleteFast(UseCaseDeleteFastParams(event.id));

    res.fold(
      (l) => emit(FastingStateFailure(l.message)),
      (r) => add(FastingEventCheckFast()),
    );
  }

  void _onFastingEventChangeFastPeriod(
      FastingEventChangeFastPeriod event, Emitter<FastingState> emit) {
    emit(FastingStateSelectedTimeRatio(FastingTimeRatioEntity(
        fast: event.fastingTimeRatio.fast, eat: event.fastingTimeRatio.eat)));
  }

  void _onFastingEventSelectJournalDate(
      FastingEventSelectJournalDate event, Emitter<FastingState> emit) async {
    final response = await _useCaseGetFastOnDate(
        UseCaseGetFastOnDateParams(event.selectedDate));

    List<FastEntity> fastEntities = [];

    response.fold(
      (l) => emit(FastingStateFailure(l.message)),
      (r) {
        fastEntities = r;
      },
    );

    emit(FastingStateSelectedJournalDate(
      selectedDate: event.selectedDate,
      fastEntities: fastEntities,
    ));
  }

  Future _onFastingEventSaveFast(
      FastingEventSaveFast event, Emitter<FastingState> emit) async {
    final response = await _useCaseSaveFast(UseCaseSaveFastParams(
        startTime: event.startTime,
        durationInMilliseconds: event.durationInMilliseconds,
        fastingTimeRatio: event.fastingTimeRatio,
        status: event.status));

    final lastFast = await _useCaseGetLastFast(const NoParams());

    response.fold(
      (l) => emit(FastingStateFailure(l.message)),
      (r) {
        lastFast.fold(
          (l) => emit(FastingStateFailure(l.message)),
          (r) => emit(FastingStateCurrentFast(r)),
        );
      },
    );
  }

  Future _onFastingCheckFast(
      FastingEventCheckFast event, Emitter<FastingState> emit) async {
    // emit(FastingStateLoading());

    final res = await _useCaseGetLastFast(const NoParams());

    res.fold(
      (l) => emit(FastingStateFailure(l.message)),
      (r) => emit(FastingStateCurrentFast(r)),
    );
  }

  Future _onFastingEventUpdateFast(
      FastingEventUpdateFast event, Emitter<FastingState> emit) async {
    final res = await _useCaseUpdateFast(UseCaseUpdateFastParams(
      isarId: event.fastEntity.isarId!,
      status: event.fastEntity.status,
      durationInMilliseconds: event.fastEntity.durationInMilliseconds,
      completedDurationInMilliseconds:
          event.fastEntity.completedDurationInMilliseconds,
      endTime: event.fastEntity.endTime,
      fastingTimeRation: event.fastEntity.fastingTimeRatio,
      note: event.fastEntity.note,
      rating: event.fastEntity.rating,
      savedOn: event.fastEntity.savedOn,
      startTime: event.fastEntity.startTime,
    ));

    res.fold(
      (l) => emit(FastingStateFailure(l.message)),
      (r) => add(FastingEventCheckFast()),
    );
  }

  @override
  void onChange(Change<FastingState> change) {
    log('\x1B[37m${change.toString()}');
    super.onChange(change);
  }
}
