import 'package:flutter_ikanban_app/core/app/app_startup/domain/errors/app_startup_error.dart';
import 'package:flutter_ikanban_app/core/app/app_startup/domain/repository/app_startup_repository.dart';
import 'package:flutter_ikanban_app/core/app/app_startup/infra/local/app_startup_data_source.dart';
import 'package:flutter_ikanban_app/core/utils/result/outcome.dart';

class AppStartupRepositoryImpl extends AppStartupRepository {
  final AppStartupDataSource dataSource;
  AppStartupRepositoryImpl(this.dataSource);

  @override
  Future<Outcome<void, AppStartupError>> completeOnBoarding() async {
    try {
      await dataSource.completeOnBoarding();
      return const Outcome.success();
    } catch (e) {
      return const Outcome.failure(error: AppStartupError.genericError());
    }
  }

  @override
  Future<Outcome<bool, AppStartupError>> isOnboardingCompleted() async {
    try {
      final result = await dataSource.isOnBoardingCompleted();
      return Outcome.success(value: result);
    } catch (e) {
      return const Outcome.failure(error: AppStartupError.genericError());
    }
  }
}
