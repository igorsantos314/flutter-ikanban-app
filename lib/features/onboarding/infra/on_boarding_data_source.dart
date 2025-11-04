import 'package:flutter_ikanban_app/core/services/shared_prefs_service.dart';

class OnBoardingDataSource {
  final SharedPrefsService _preferences = SharedPrefsService.instance;
  static const String onBoardingKey = 'on_boarding_completed';

  Future<bool> isOnBoardingCompleted() async {
    return await _preferences.getBool(onBoardingKey) ?? false;
  }

  Future<void> completeOnBoarding() async {
    await _preferences.setBool(onBoardingKey, true);
  }
}
