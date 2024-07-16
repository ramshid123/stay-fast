import 'package:fasting_app/core/shared_preferences_strings/shared_pref_strings.dart';
import 'package:fasting_app/init_dependencies.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';

Future vibrate() async {
  final sf = serviceLocator<SharedPreferences>();
  bool isAllowed = sf.getBool(SharedPrefStrings.isVibrationAllowed) ?? true;
  if ((await Vibration.hasVibrator() ?? false) && isAllowed) {
    await Vibration.vibrate(duration: 30);
  }
}
