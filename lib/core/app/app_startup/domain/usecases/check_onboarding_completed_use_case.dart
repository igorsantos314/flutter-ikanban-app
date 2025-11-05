import 'package:flutter_ikanban_app/core/app/app_startup/domain/repository/app_startup_repository.dart';
import 'package:flutter_ikanban_app/core/utils/result/outcome.dart';
import 'package:flutter_ikanban_app/core/app/app_startup/domain/errors/app_startup_error.dart';

enum CheckOnboardingCompletedError { genericError, notFound }

class CheckOnboardingCompletedUseCase {
  final AppStartupRepository repository;
  CheckOnboardingCompletedUseCase(this.repository);
  
  Future<Outcome<bool, CheckOnboardingCompletedError>> execute() async {
    final result = await repository.isOnboardingCompleted();
    return result.when(
      success: (data) => Outcome.success(value: data),
      failure: (error, message, throwable) {
        switch (error) {
          case AppStartupError.notFound:
            return const Outcome.failure(
              error: CheckOnboardingCompletedError.notFound,
            );
          default:
            return const Outcome.failure(
              error: CheckOnboardingCompletedError.genericError,
            );
        }
      },
    );
  }
}