import 'package:isar/isar.dart';

part 'time_ration_entity.g.dart';

@embedded
class FastingTimeRatioEntity {
  final int? fast;
  final int? eat;

  FastingTimeRatioEntity({this.fast, this.eat});

  @override
  String toString() {
    return 'FastEntity{'
        'fast: $fast, '
        'eat: $eat, '
        '}';
  }
}
