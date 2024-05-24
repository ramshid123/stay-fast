part of 'fasting_bloc.dart';

@immutable
sealed class FastingEvent {}

final class FastingEventSaveFast extends FastingEvent {
  final DateTime startTime;
  final int durationInMilliseconds;
  final FastingTimeRatioEntity fastingTimeRatio;
  final FastStatus status;

  FastingEventSaveFast(
      {required this.startTime,
      required this.durationInMilliseconds,
      required this.fastingTimeRatio,
      required this.status});
}

final class FastingEventChangeFastPeriod extends FastingEvent {
  final FastingTimeRatioEntity fastingTimeRatio;

  FastingEventChangeFastPeriod(this.fastingTimeRatio);
}

final class FastingEventUpdateFast extends FastingEvent {
  final FastEntity fastEntity;

  FastingEventUpdateFast(this.fastEntity);
}

final class FastingEventGetFastOnDate extends FastingEvent {
  final DateTime savedOn;

  FastingEventGetFastOnDate(this.savedOn);
}

final class FastingEventStartFast extends FastingEvent {}

final class FastingEventFinishFast extends FastingEvent {}

final class FastingEventCheckFast extends FastingEvent {}

final class FastingEventSelectJournalDate extends FastingEvent {
  final DateTime selectedDate;

  FastingEventSelectJournalDate(this.selectedDate);
}
