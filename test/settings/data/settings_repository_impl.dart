import 'package:flutter_ikanban_app/core/utils/result/outcome.dart';
import 'package:flutter_ikanban_app/features/settings/data/settings_repository_impl.dart';
import 'package:flutter_ikanban_app/features/settings/domain/model/settings_model.dart';
import 'package:flutter_ikanban_app/shared/theme/presentation/theme_enum.dart';
import 'package:flutter_ikanban_app/shared/theme/repository/theme_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockThemeRepository extends Mock implements ThemeRepository {}

void main() {
  late MockThemeRepository mockThemeRepository;
  late SettingsRepositoryImpl repository;

  setUp(() {
    mockThemeRepository = MockThemeRepository();
    repository = SettingsRepositoryImpl(
      themeRepository: mockThemeRepository,
    );
  });

  group('SettingsRepositoryImpl', () {
    group('loadSettings', () {
      test('should return settings when theme repository returns theme successfully', () async {
        // Arrange
        when(() => mockThemeRepository.getTheme())
            .thenAnswer((_) async => AppTheme.dark);

        // Act
        final result = await repository.loadSettings();

        // Assert
        result.when(
          success: (settings) {
            expect(settings?.appTheme, AppTheme.dark);
            expect(settings?.language, 'pt');
            expect(settings?.appVersion, isNotEmpty);
          },
          failure: (_, __, ___) => fail('Should return success'),
        );
        verify(() => mockThemeRepository.getTheme()).called(1);
      });

      test('should return light theme when theme repository returns light', () async {
        // Arrange
        when(() => mockThemeRepository.getTheme())
            .thenAnswer((_) async => AppTheme.light);

        // Act
        final result = await repository.loadSettings();

        // Assert
        result.when(
          success: (settings) {
            expect(settings?.appTheme, AppTheme.light);
          },
          failure: (_, __, ___) => fail('Should return success'),
        );
      });

      test('should return system theme when theme repository returns system', () async {
        // Arrange
        when(() => mockThemeRepository.getTheme())
            .thenAnswer((_) async => AppTheme.system);

        // Act
        final result = await repository.loadSettings();

        // Assert
        result.when(
          success: (settings) {
            expect(settings?.appTheme, AppTheme.system);
          },
          failure: (_, __, ___) => fail('Should return success'),
        );
      });

      test('should return genericError when theme repository throws exception', () async {
        // Arrange
        when(() => mockThemeRepository.getTheme())
            .thenThrow(Exception('Theme loading failed'));

        // Act
        final result = await repository.loadSettings();

        // Assert
        result.when(
          success: (_) => fail('Should return failure'),
          failure: (error, message, throwable) {
            expect(message, 'Failed to load settings');
            expect(throwable, isA<Exception>());
          },
        );
        verify(() => mockThemeRepository.getTheme()).called(1);
      });
    });

    group('saveSettings', () {
      test('should return success when theme repository saves theme successfully', () async {
        // Arrange
        final settings = SettingsModel(
          appTheme: AppTheme.dark,
          language: 'pt',
          appVersion: '1.0.0 (1)',
        );
        when(() => mockThemeRepository.setTheme(any()))
            .thenAnswer((_) async => {});

        // Act
        final result = await repository.saveSettings(settings);

        // Assert
        result.when(
          success: (_) => expect(true, true),
          failure: (_, __, ___) => fail('Should return success'),
        );
        verify(() => mockThemeRepository.setTheme(AppTheme.dark)).called(1);
      });

      test('should call theme repository with correct theme', () async {
        // Arrange
        final settings = SettingsModel(
          appTheme: AppTheme.light,
          language: 'en',
          appVersion: '2.0.0 (10)',
        );
        when(() => mockThemeRepository.setTheme(any()))
            .thenAnswer((_) async => {});

        // Act
        await repository.saveSettings(settings);

        // Assert
        verify(() => mockThemeRepository.setTheme(AppTheme.light)).called(1);
      });

      test('should return genericError when theme repository throws exception', () async {
        // Arrange
        final settings = SettingsModel(
          appTheme: AppTheme.dark,
          language: 'pt',
          appVersion: '1.0.0 (1)',
        );
        when(() => mockThemeRepository.setTheme(any()))
            .thenThrow(Exception('Theme saving failed'));

        // Act
        final result = await repository.saveSettings(settings);

        // Assert
        result.when(
          success: (_) => fail('Should return failure'),
          failure: (error, message, throwable) {
            expect(message, 'Failed to save settings');
            expect(throwable, isA<Exception>());
          },
        );
        verify(() => mockThemeRepository.setTheme(AppTheme.dark)).called(1);
      });
    });
  });
}
