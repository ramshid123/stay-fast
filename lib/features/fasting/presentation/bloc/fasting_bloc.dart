import 'dart:developer';

import 'package:fasting_app/core/entities/time_ration_entity.dart';
import 'package:fasting_app/core/usecase/use_case.dart';
import 'package:fasting_app/core/entities/fast_entity.dart';
import 'package:fasting_app/features/fasting/domain/use%20cases/get_fast_on_date.dart';
import 'package:fasting_app/features/fasting/domain/use%20cases/get_last_fast.dart';
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

  FastingBloc({
    required UseCaseSaveFast useCaseSaveFast,
    required UseCaseGetLastFast useCaseGetLastFast,
    required UseCaseUpdateFast useCaseUpdateFast,
    required UseCaseGetFastOnDate useCaseGetFastOnDate,
  })  : _useCaseSaveFast = useCaseSaveFast,
        _useCaseGetLastFast = useCaseGetLastFast,
        _useCaseUpdateFast = useCaseUpdateFast,
        _useCaseGetFastOnDate = useCaseGetFastOnDate,
        super(FastingStateInitial()) {
    on<FastingEventCheckFast>(
        (event, emit) async => await _onFastingCheckFast(event, emit));
    on<FastingEventSaveFast>(
        (event, emit) async => await _onFastingEventSaveFast(event, emit));

    on<FastingEventChangeFastPeriod>(
        (event, emit) => _onFastingEventChangeFastPeriod(event, emit));

    on<FastingEventUpdateFast>(
        (event, emit) async => await _onFastingEventUpdateFast(event, emit));

    on<FastingEventGetFastOnDate>(
        (event, emit) async => await _onFastingEventGetFastOnDate(event, emit));
    on<FastingEventSelectJournalDate>(
        (event, emit) => _onFastingEventSelectJournalDate(event, emit));
  }

  void _onFastingEventChangeFastPeriod(
      FastingEventChangeFastPeriod event, Emitter<FastingState> emit) {
    emit(FastingStateSelectedTimeRatio(FastingTimeRatioEntity(
        fast: event.fastingTimeRatio.fast, eat: event.fastingTimeRatio.eat)));
  }

  Future _onFastingEventGetFastOnDate(
      FastingEventGetFastOnDate event, Emitter<FastingState> emit) async {
    final res =
        await _useCaseGetFastOnDate(UseCaseGetFastOnDateParams(event.savedOn));

    res.fold(
      (l) => emit(FastingStateFailure(l.message)),
      (r) => emit(FastingStateJournalItem(r)),
    );
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
    emit(FastingStateLoading());

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
