// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_preference_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ThemePreferenceModel _$ThemePreferenceModelFromJson(
  Map<String, dynamic> json,
) => _ThemePreferenceModel(
  selectedTheme:
      $enumDecodeNullable(_$AppThemeEnumMap, json['selectedTheme']) ??
      AppTheme.system,
  followSystemTheme: json['followSystemTheme'] as bool? ?? true,
  lastUpdated: json['lastUpdated'] == null
      ? null
      : DateTime.parse(json['lastUpdated'] as String),
);

Map<String, dynamic> _$ThemePreferenceModelToJson(
  _ThemePreferenceModel instance,
) => <String, dynamic>{
  'selectedTheme': _$AppThemeEnumMap[instance.selectedTheme]!,
  'followSystemTheme': instance.followSystemTheme,
  'lastUpdated': instance.lastUpdated?.toIso8601String(),
};

const _$AppThemeEnumMap = {
  AppTheme.system: 'system',
  AppTheme.light: 'light',
  AppTheme.dark: 'dark',
};
