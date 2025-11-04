import 'package:flutter_ikanban_app/core/utils/result/outcome.dart';
import 'package:flutter_ikanban_app/features/onboarding/domain/repository/on_boarding_repository.dart';

enum CompleteOnBoardingResult { success, failure }

class CompleteOnBoarding {
  final OnBoardingRepository repository;

  CompleteOnBoarding(this.repository);

  Future<Outcome<void, CompleteOnBoardingResult>> execute() async {
    final result = await repository.completeOnBoarding();
    return result.when(
      success: (_) => const Outcome.success(),
      failure: (error, message, throwable) =>
          Outcome.failure(error: CompleteOnBoardingResult.failure),
    );
  }
}
