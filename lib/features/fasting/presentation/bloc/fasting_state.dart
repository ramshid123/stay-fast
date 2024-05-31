part of 'fasting_bloc.dart';

@immutable
sealed class FastingState {}

final class FastingStateInitial extends FastingState {}

final class FastingStateLoading extends FastingState {}

final class FastingStateSuccess extends FastingState {}

final class FastingStateFailure extends FastingState {
  final String message;

  FastingStateFailure(this.message);
}

final class FastingStateSelectedTimeRatio extends FastingState {
  final FastingTimeRatioEntity fastingTimeRatio;

  FastingStateSelectedTimeRatio(this.fastingTimeRatio);
}

final class FastingStateCurrentFast extends FastingState {
  final FastEntity? fastEntity;

  FastingStateCurrentFast(this.fastEntity);
}

final class FastingStateSelectedJournalDate extends FastingState {
  final DateTime selectedDate;
  final List<FastEntity> fastEntities;

  FastingStateSelectedJournalDate(
      {required this.selectedDate, required this.fastEntities});
}

final class FastingStateAllFasts extends FastingState {
  final int totalFasts;
  final int longestFast;
  final int totalFastingHours;
  final int daysWithFast;
  final List<FastEntity> fastList;

  FastingStateAllFasts({
    required this.totalFasts,
    required this.longestFast,
    required this.totalFastingHours,
    required this.daysWithFast,
    required this.fastList,
  });
}
