import 'package:flutter_ikanban_app/core/utils/result/outcome.dart';
import 'package:flutter_ikanban_app/features/settings/domain/errors/settings_repository_errors.dart';
import 'package:flutter_ikanban_app/features/settings/domain/model/settings_model.dart';
import 'package:flutter_ikanban_app/features/settings/domain/repository/settings_repository.dart';
import 'package:flutter_ikanban_app/features/settings/domain/use_cases/load_settings_use_case.dart';
import 'package:flutter_ikanban_app/shared/theme/presentation/theme_enum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSettingsRepository extends Mock implements SettingsRepository {}

void main() {
  late MockSettingsRepository mockRepository;
  late LoadSettingsUseCase useCase;

  final testSettings = SettingsModel(
    appTheme: AppTheme.dark,
    language: 'pt',
    appVersion: '1.0.0 (1)',
  );

  setUp(() {
    mockRepository = MockSettingsRepository();
    useCase = LoadSettingsUseCase(settingsRepository: mockRepository);
  });

  group('LoadSettingsUseCase', () {
    group('execute', () {
      test('should return settings when repository loads successfully', () async {
        // Arrange
        when(() => mockRepository.loadSettings())
            .thenAnswer((_) async => Outcome.success(value: testSettings));

        // Act
        final result = await useCase.execute();

        // Assert
        result.when(
          success: (settings) {
            expect(settings, testSettings);
            expect(settings?.appTheme, AppTheme.dark);
            expect(settings?.language, 'pt');
            expect(settings?.appVersion, '1.0.0 (1)');
          },
          failure: (_, __, ___) => fail('Should return success'),
        );
        verify(() => mockRepository.loadSettings()).called(1);
      });

      test('should return unknown error when repository returns notFound', () async {
        // Arrange
        when(() => mockRepository.loadSettings())
            .thenAnswer((_) async => const Outcome.failure(
                  error: SettingsRepositoryErrors.notFound(),
                ));

        // Act
        final result = await useCase.execute();

        // Assert
        result.when(
          success: (_) => fail('Should return failure'),
          failure: (error, message, throwable) {
            expect(error, LoadSettingsError.unknown);
          },
        );
        verify(() => mockRepository.loadSettings()).called(1);
      });

      test('should return unknown error when repository returns databaseError', () async {
        // Arrange
        when(() => mockRepository.loadSettings())
            .thenAnswer((_) async => const Outcome.failure(
                  error: SettingsRepositoryErrors.databaseError(),
                ));

        // Act
        final result = await useCase.execute();

        // Assert
        result.when(
          success: (_) => fail('Should return failure'),
          failure: (error, message, throwable) {
            expect(error, LoadSettingsError.unknown);
          },
        );
        verify(() => mockRepository.loadSettings()).called(1);
      });

      test('should return unknown error when repository returns genericError', () async {
        // Arrange
        when(() => mockRepository.loadSettings())
            .thenAnswer((_) async => const Outcome.failure(
                  error: SettingsRepositoryErrors.genericError(),
                ));

        // Act
        final result = await useCase.execute();

        // Assert
        result.when(
          success: (_) => fail('Should return failure'),
          failure: (error, message, throwable) {
            expect(error, LoadSettingsError.unknown);
          },
        );
        verify(() => mockRepository.loadSettings()).called(1);
      });

      test('should call repository only once', () async {
        // Arrange
        when(() => mockRepository.loadSettings())
            .thenAnswer((_) async => Outcome.success(value: testSettings));

        // Act
        await useCase.execute();

        // Assert
        verify(() => mockRepository.loadSettings()).called(1);
      });
    });
  });
}
