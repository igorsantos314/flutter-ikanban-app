import 'package:flutter_ikanban_app/core/app/app_startup/domain/repository/app_startup_repository.dart';
import 'package:flutter_ikanban_app/core/utils/result/outcome.dart';

enum CompleteOnBoardingResult { success, failure }

class CompleteOnBoardingUseCase {
  final AppStartupRepository repository;

  CompleteOnBoardingUseCase(this.repository);

  Future<Outcome<void, CompleteOnBoardingResult>> execute() async {
    final result = await repository.completeOnBoarding();
    return result.when(
      success: (_) => const Outcome.success(),
      failure: (error, message, throwable) =>
          Outcome.failure(error: CompleteOnBoardingResult.failure),
    );
  }
}
