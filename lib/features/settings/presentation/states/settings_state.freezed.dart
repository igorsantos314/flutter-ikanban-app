// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settings_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SettingsState {

 SettingsModel? get settingsModel; AppTheme get appTheme; String get language; String get appVersion; bool get isLoading; bool get showNotification; NotificationType get notificationType; String get notificationMessage;
/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsStateCopyWith<SettingsState> get copyWith => _$SettingsStateCopyWithImpl<SettingsState>(this as SettingsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsState&&(identical(other.settingsModel, settingsModel) || other.settingsModel == settingsModel)&&(identical(other.appTheme, appTheme) || other.appTheme == appTheme)&&(identical(other.language, language) || other.language == language)&&(identical(other.appVersion, appVersion) || other.appVersion == appVersion)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.showNotification, showNotification) || other.showNotification == showNotification)&&(identical(other.notificationType, notificationType) || other.notificationType == notificationType)&&(identical(other.notificationMessage, notificationMessage) || other.notificationMessage == notificationMessage));
}


@override
int get hashCode => Object.hash(runtimeType,settingsModel,appTheme,language,appVersion,isLoading,showNotification,notificationType,notificationMessage);

@override
String toString() {
  return 'SettingsState(settingsModel: $settingsModel, appTheme: $appTheme, language: $language, appVersion: $appVersion, isLoading: $isLoading, showNotification: $showNotification, notificationType: $notificationType, notificationMessage: $notificationMessage)';
}


}

/// @nodoc
abstract mixin class $SettingsStateCopyWith<$Res>  {
  factory $SettingsStateCopyWith(SettingsState value, $Res Function(SettingsState) _then) = _$SettingsStateCopyWithImpl;
@useResult
$Res call({
 SettingsModel? settingsModel, AppTheme appTheme, String language, String appVersion, bool isLoading, bool showNotification, NotificationType notificationType, String notificationMessage
});


$SettingsModelCopyWith<$Res>? get settingsModel;

}
/// @nodoc
class _$SettingsStateCopyWithImpl<$Res>
    implements $SettingsStateCopyWith<$Res> {
  _$SettingsStateCopyWithImpl(this._self, this._then);

  final SettingsState _self;
  final $Res Function(SettingsState) _then;

/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? settingsModel = freezed,Object? appTheme = null,Object? language = null,Object? appVersion = null,Object? isLoading = null,Object? showNotification = null,Object? notificationType = null,Object? notificationMessage = null,}) {
  return _then(_self.copyWith(
settingsModel: freezed == settingsModel ? _self.settingsModel : settingsModel // ignore: cast_nullable_to_non_nullable
as SettingsModel?,appTheme: null == appTheme ? _self.appTheme : appTheme // ignore: cast_nullable_to_non_nullable
as AppTheme,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String,appVersion: null == appVersion ? _self.appVersion : appVersion // ignore: cast_nullable_to_non_nullable
as String,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,showNotification: null == showNotification ? _self.showNotification : showNotification // ignore: cast_nullable_to_non_nullable
as bool,notificationType: null == notificationType ? _self.notificationType : notificationType // ignore: cast_nullable_to_non_nullable
as NotificationType,notificationMessage: null == notificationMessage ? _self.notificationMessage : notificationMessage // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SettingsModelCopyWith<$Res>? get settingsModel {
    if (_self.settingsModel == null) {
    return null;
  }

  return $SettingsModelCopyWith<$Res>(_self.settingsModel!, (value) {
    return _then(_self.copyWith(settingsModel: value));
  });
}
}


/// Adds pattern-matching-related methods to [SettingsState].
extension SettingsStatePatterns on SettingsState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SettingsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SettingsState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SettingsState value)  $default,){
final _that = this;
switch (_that) {
case _SettingsState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SettingsState value)?  $default,){
final _that = this;
switch (_that) {
case _SettingsState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( SettingsModel? settingsModel,  AppTheme appTheme,  String language,  String appVersion,  bool isLoading,  bool showNotification,  NotificationType notificationType,  String notificationMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SettingsState() when $default != null:
return $default(_that.settingsModel,_that.appTheme,_that.language,_that.appVersion,_that.isLoading,_that.showNotification,_that.notificationType,_that.notificationMessage);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( SettingsModel? settingsModel,  AppTheme appTheme,  String language,  String appVersion,  bool isLoading,  bool showNotification,  NotificationType notificationType,  String notificationMessage)  $default,) {final _that = this;
switch (_that) {
case _SettingsState():
return $default(_that.settingsModel,_that.appTheme,_that.language,_that.appVersion,_that.isLoading,_that.showNotification,_that.notificationType,_that.notificationMessage);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( SettingsModel? settingsModel,  AppTheme appTheme,  String language,  String appVersion,  bool isLoading,  bool showNotification,  NotificationType notificationType,  String notificationMessage)?  $default,) {final _that = this;
switch (_that) {
case _SettingsState() when $default != null:
return $default(_that.settingsModel,_that.appTheme,_that.language,_that.appVersion,_that.isLoading,_that.showNotification,_that.notificationType,_that.notificationMessage);case _:
  return null;

}
}

}

/// @nodoc


class _SettingsState implements SettingsState {
  const _SettingsState({this.settingsModel, this.appTheme = AppTheme.system, this.language = 'pt', this.appVersion = '0.0.1', this.isLoading = false, this.showNotification = false, this.notificationType = NotificationType.info, this.notificationMessage = ""});
  

@override final  SettingsModel? settingsModel;
@override@JsonKey() final  AppTheme appTheme;
@override@JsonKey() final  String language;
@override@JsonKey() final  String appVersion;
@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool showNotification;
@override@JsonKey() final  NotificationType notificationType;
@override@JsonKey() final  String notificationMessage;

/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SettingsStateCopyWith<_SettingsState> get copyWith => __$SettingsStateCopyWithImpl<_SettingsState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SettingsState&&(identical(other.settingsModel, settingsModel) || other.settingsModel == settingsModel)&&(identical(other.appTheme, appTheme) || other.appTheme == appTheme)&&(identical(other.language, language) || other.language == language)&&(identical(other.appVersion, appVersion) || other.appVersion == appVersion)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.showNotification, showNotification) || other.showNotification == showNotification)&&(identical(other.notificationType, notificationType) || other.notificationType == notificationType)&&(identical(other.notificationMessage, notificationMessage) || other.notificationMessage == notificationMessage));
}


@override
int get hashCode => Object.hash(runtimeType,settingsModel,appTheme,language,appVersion,isLoading,showNotification,notificationType,notificationMessage);

@override
String toString() {
  return 'SettingsState(settingsModel: $settingsModel, appTheme: $appTheme, language: $language, appVersion: $appVersion, isLoading: $isLoading, showNotification: $showNotification, notificationType: $notificationType, notificationMessage: $notificationMessage)';
}


}

/// @nodoc
abstract mixin class _$SettingsStateCopyWith<$Res> implements $SettingsStateCopyWith<$Res> {
  factory _$SettingsStateCopyWith(_SettingsState value, $Res Function(_SettingsState) _then) = __$SettingsStateCopyWithImpl;
@override @useResult
$Res call({
 SettingsModel? settingsModel, AppTheme appTheme, String language, String appVersion, bool isLoading, bool showNotification, NotificationType notificationType, String notificationMessage
});


@override $SettingsModelCopyWith<$Res>? get settingsModel;

}
/// @nodoc
class __$SettingsStateCopyWithImpl<$Res>
    implements _$SettingsStateCopyWith<$Res> {
  __$SettingsStateCopyWithImpl(this._self, this._then);

  final _SettingsState _self;
  final $Res Function(_SettingsState) _then;

/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? settingsModel = freezed,Object? appTheme = null,Object? language = null,Object? appVersion = null,Object? isLoading = null,Object? showNotification = null,Object? notificationType = null,Object? notificationMessage = null,}) {
  return _then(_SettingsState(
settingsModel: freezed == settingsModel ? _self.settingsModel : settingsModel // ignore: cast_nullable_to_non_nullable
as SettingsModel?,appTheme: null == appTheme ? _self.appTheme : appTheme // ignore: cast_nullable_to_non_nullable
as AppTheme,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String,appVersion: null == appVersion ? _self.appVersion : appVersion // ignore: cast_nullable_to_non_nullable
as String,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,showNotification: null == showNotification ? _self.showNotification : showNotification // ignore: cast_nullable_to_non_nullable
as bool,notificationType: null == notificationType ? _self.notificationType : notificationType // ignore: cast_nullable_to_non_nullable
as NotificationType,notificationMessage: null == notificationMessage ? _self.notificationMessage : notificationMessage // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SettingsModelCopyWith<$Res>? get settingsModel {
    if (_self.settingsModel == null) {
    return null;
  }

  return $SettingsModelCopyWith<$Res>(_self.settingsModel!, (value) {
    return _then(_self.copyWith(settingsModel: value));
  });
}
}

// dart format on
