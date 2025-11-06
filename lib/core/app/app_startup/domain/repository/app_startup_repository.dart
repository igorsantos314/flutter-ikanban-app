import 'package:flutter_ikanban_app/core/app/app_startup/domain/errors/app_startup_error.dart';
import 'package:flutter_ikanban_app/core/utils/result/outcome.dart';

abstract class AppStartupRepository {
  Future<Outcome<bool, AppStartupError>> isOnboardingCompleted();
  Future<Outcome<void, AppStartupError>> completeOnBoarding();
}
