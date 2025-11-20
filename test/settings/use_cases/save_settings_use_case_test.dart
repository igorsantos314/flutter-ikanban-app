import 'package:flutter_ikanban_app/core/utils/result/outcome.dart';
import 'package:flutter_ikanban_app/features/settings/domain/errors/settings_repository_errors.dart';
import 'package:flutter_ikanban_app/features/settings/domain/model/settings_model.dart';
import 'package:flutter_ikanban_app/features/settings/domain/repository/settings_repository.dart';
import 'package:flutter_ikanban_app/features/settings/domain/use_cases/save_settings_use_case.dart';
import 'package:flutter_ikanban_app/shared/theme/presentation/theme_enum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSettingsRepository extends Mock implements SettingsRepository {}

class FakeSettingsModel extends Fake implements SettingsModel {}

void main() {
  late MockSettingsRepository mockRepository;
  late SaveSettingsUseCase useCase;
  late SettingsModel testSettings;

  setUpAll(() {
    registerFallbackValue(FakeSettingsModel());
  });

  setUp(() {
    mockRepository = MockSettingsRepository();
    useCase = SaveSettingsUseCase(settingsRepository: mockRepository);
    testSettings = SettingsModel(
      appTheme: AppTheme.dark,
      language: 'pt',
      appVersion: '1.0.0 (1)',
    );
  });

  group('SaveSettingsUseCase', () {
    group('execute', () {
      test('should return success when repository saves successfully', () async {
        // Arrange
        when(() => mockRepository.saveSettings(any()))
            .thenAnswer((_) async => const Outcome.success());

        // Act
        final result = await useCase.execute(testSettings);

        // Assert
        result.when(
          success: (_) => expect(true, true),
          failure: (_, __, ___) => fail('Should return success'),
        );
        verify(() => mockRepository.saveSettings(testSettings)).called(1);
      });

      test('should return unknown error when repository returns notFound', () async {
        // Arrange
        when(() => mockRepository.saveSettings(any()))
            .thenAnswer((_) async => const Outcome.failure(
                  error: SettingsRepositoryErrors.notFound(),
                ));

        // Act
        final result = await useCase.execute(testSettings);

        // Assert
        result.when(
          success: (_) => fail('Should return failure'),
          failure: (error, message, throwable) {
            expect(error, SaveSettingsError.unknown);
          },
        );
        verify(() => mockRepository.saveSettings(testSettings)).called(1);
      });

      test('should return unknown error when repository returns databaseError', () async {
        // Arrange
        when(() => mockRepository.saveSettings(any()))
            .thenAnswer((_) async => const Outcome.failure(
                  error: SettingsRepositoryErrors.databaseError(),
                ));

        // Act
        final result = await useCase.execute(testSettings);

        // Assert
        result.when(
          success: (_) => fail('Should return failure'),
          failure: (error, message, throwable) {
            expect(error, SaveSettingsError.unknown);
          },
        );
        verify(() => mockRepository.saveSettings(testSettings)).called(1);
      });

      test('should return unknown error when repository returns genericError', () async {
        // Arrange
        when(() => mockRepository.saveSettings(any()))
            .thenAnswer((_) async => const Outcome.failure(
                  error: SettingsRepositoryErrors.genericError(),
                ));

        // Act
        final result = await useCase.execute(testSettings);

        // Assert
        result.when(
          success: (_) => fail('Should return failure'),
          failure: (error, message, throwable) {
            expect(error, SaveSettingsError.unknown);
          },
        );
        verify(() => mockRepository.saveSettings(testSettings)).called(1);
      });

      test('should call repository with correct settings', () async {
        // Arrange
        final specificSettings = SettingsModel(
          appTheme: AppTheme.light,
          language: 'en',
          appVersion: '2.0.0 (42)',
        );
        when(() => mockRepository.saveSettings(any()))
            .thenAnswer((_) async => const Outcome.success());

        // Act
        await useCase.execute(specificSettings);

        // Assert
        verify(() => mockRepository.saveSettings(specificSettings)).called(1);
      });
    });
  });
}
