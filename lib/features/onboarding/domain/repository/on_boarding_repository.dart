import 'package:flutter_ikanban_app/core/utils/result/outcome.dart';
import 'package:flutter_ikanban_app/features/onboarding/domain/errors/on_boarding_errors.dart';

abstract class OnBoardingRepository {
  Future<Outcome<bool, OnBoardingError>> isOnBoardingCompleted();
  Future<Outcome<void, OnBoardingError>> completeOnBoarding();
}
