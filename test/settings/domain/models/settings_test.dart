
import 'package:flutter_ikanban_app/features/settings/domain/model/settings_model.dart';
import 'package:flutter_ikanban_app/shared/theme/presentation/theme_enum.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SettingsModel', () {
    group('Test access of attributes', () {
      final SettingsModel settings = SettingsModel(
        appTheme: AppTheme.dark,
        language: 'pt',
        appVersion: '1.0.0 (1)',
      );

      test('Access attributes', () {
        expect(settings.appTheme, AppTheme.dark);
        expect(settings.language, 'pt');
        expect(settings.appVersion, '1.0.0 (1)');
      });

      test('Default appTheme should be system', () {
        const defaultSettings = SettingsModel(
          language: 'en',
          appVersion: '1.0.0',
        );
        expect(defaultSettings.appTheme, AppTheme.system);
      });
    });

    group('Equality', () {
      test('should be equal when all properties are the same', () {
        final settings1 = SettingsModel(
          appTheme: AppTheme.light,
          language: 'pt',
          appVersion: '1.0.0 (1)',
        );
        final settings2 = SettingsModel(
          appTheme: AppTheme.light,
          language: 'pt',
          appVersion: '1.0.0 (1)',
        );
        expect(settings1, equals(settings2));
        expect(settings1.hashCode, equals(settings2.hashCode));
      });

      test('should not be equal when appTheme is different', () {
        final settings1 = SettingsModel(
          appTheme: AppTheme.light,
          language: 'pt',
          appVersion: '1.0.0 (1)',
        );
        final settings2 = SettingsModel(
          appTheme: AppTheme.dark,
          language: 'pt',
          appVersion: '1.0.0 (1)',
        );
        expect(settings1, isNot(equals(settings2)));
      });

      test('should not be equal when language is different', () {
        final settings1 = SettingsModel(
          appTheme: AppTheme.light,
          language: 'pt',
          appVersion: '1.0.0 (1)',
        );
        final settings2 = SettingsModel(
          appTheme: AppTheme.light,
          language: 'en',
          appVersion: '1.0.0 (1)',
        );
        expect(settings1, isNot(equals(settings2)));
      });
    });

    group('CopyWith', () {
      test('should create copy with updated appTheme', () {
        final settings = SettingsModel(
          appTheme: AppTheme.light,
          language: 'pt',
          appVersion: '1.0.0 (1)',
        );
        final updatedSettings = settings.copyWith(appTheme: AppTheme.dark);
        expect(updatedSettings.appTheme, AppTheme.dark);
        expect(updatedSettings.language, 'pt');
        expect(updatedSettings.appVersion, '1.0.0 (1)');
      });

      test('should create copy with updated language', () {
        final settings = SettingsModel(
          appTheme: AppTheme.light,
          language: 'pt',
          appVersion: '1.0.0 (1)',
        );
        final updatedSettings = settings.copyWith(language: 'en');
        expect(updatedSettings.appTheme, AppTheme.light);
        expect(updatedSettings.language, 'en');
        expect(updatedSettings.appVersion, '1.0.0 (1)');
      });

      test('should create copy with updated appVersion', () {
        final settings = SettingsModel(
          appTheme: AppTheme.light,
          language: 'pt',
          appVersion: '1.0.0 (1)',
        );
        final updatedSettings = settings.copyWith(appVersion: '2.0.0 (10)');
        expect(updatedSettings.appTheme, AppTheme.light);
        expect(updatedSettings.language, 'pt');
        expect(updatedSettings.appVersion, '2.0.0 (10)');
      });
    });
  });
}