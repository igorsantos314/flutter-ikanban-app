// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'theme_preference_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ThemePreferenceModel {

 AppTheme get selectedTheme; bool get followSystemTheme; DateTime? get lastUpdated;
/// Create a copy of ThemePreferenceModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ThemePreferenceModelCopyWith<ThemePreferenceModel> get copyWith => _$ThemePreferenceModelCopyWithImpl<ThemePreferenceModel>(this as ThemePreferenceModel, _$identity);

  /// Serializes this ThemePreferenceModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ThemePreferenceModel&&(identical(other.selectedTheme, selectedTheme) || other.selectedTheme == selectedTheme)&&(identical(other.followSystemTheme, followSystemTheme) || other.followSystemTheme == followSystemTheme)&&(identical(other.lastUpdated, lastUpdated) || other.lastUpdated == lastUpdated));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,selectedTheme,followSystemTheme,lastUpdated);

@override
String toString() {
  return 'ThemePreferenceModel(selectedTheme: $selectedTheme, followSystemTheme: $followSystemTheme, lastUpdated: $lastUpdated)';
}


}

/// @nodoc
abstract mixin class $ThemePreferenceModelCopyWith<$Res>  {
  factory $ThemePreferenceModelCopyWith(ThemePreferenceModel value, $Res Function(ThemePreferenceModel) _then) = _$ThemePreferenceModelCopyWithImpl;
@useResult
$Res call({
 AppTheme selectedTheme, bool followSystemTheme, DateTime? lastUpdated
});




}
/// @nodoc
class _$ThemePreferenceModelCopyWithImpl<$Res>
    implements $ThemePreferenceModelCopyWith<$Res> {
  _$ThemePreferenceModelCopyWithImpl(this._self, this._then);

  final ThemePreferenceModel _self;
  final $Res Function(ThemePreferenceModel) _then;

/// Create a copy of ThemePreferenceModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? selectedTheme = null,Object? followSystemTheme = null,Object? lastUpdated = freezed,}) {
  return _then(_self.copyWith(
selectedTheme: null == selectedTheme ? _self.selectedTheme : selectedTheme // ignore: cast_nullable_to_non_nullable
as AppTheme,followSystemTheme: null == followSystemTheme ? _self.followSystemTheme : followSystemTheme // ignore: cast_nullable_to_non_nullable
as bool,lastUpdated: freezed == lastUpdated ? _self.lastUpdated : lastUpdated // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ThemePreferenceModel].
extension ThemePreferenceModelPatterns on ThemePreferenceModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ThemePreferenceModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ThemePreferenceModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ThemePreferenceModel value)  $default,){
final _that = this;
switch (_that) {
case _ThemePreferenceModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ThemePreferenceModel value)?  $default,){
final _that = this;
switch (_that) {
case _ThemePreferenceModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AppTheme selectedTheme,  bool followSystemTheme,  DateTime? lastUpdated)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ThemePreferenceModel() when $default != null:
return $default(_that.selectedTheme,_that.followSystemTheme,_that.lastUpdated);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AppTheme selectedTheme,  bool followSystemTheme,  DateTime? lastUpdated)  $default,) {final _that = this;
switch (_that) {
case _ThemePreferenceModel():
return $default(_that.selectedTheme,_that.followSystemTheme,_that.lastUpdated);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AppTheme selectedTheme,  bool followSystemTheme,  DateTime? lastUpdated)?  $default,) {final _that = this;
switch (_that) {
case _ThemePreferenceModel() when $default != null:
return $default(_that.selectedTheme,_that.followSystemTheme,_that.lastUpdated);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ThemePreferenceModel extends ThemePreferenceModel {
  const _ThemePreferenceModel({this.selectedTheme = AppTheme.system, this.followSystemTheme = true, this.lastUpdated}): super._();
  factory _ThemePreferenceModel.fromJson(Map<String, dynamic> json) => _$ThemePreferenceModelFromJson(json);

@override@JsonKey() final  AppTheme selectedTheme;
@override@JsonKey() final  bool followSystemTheme;
@override final  DateTime? lastUpdated;

/// Create a copy of ThemePreferenceModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ThemePreferenceModelCopyWith<_ThemePreferenceModel> get copyWith => __$ThemePreferenceModelCopyWithImpl<_ThemePreferenceModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ThemePreferenceModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ThemePreferenceModel&&(identical(other.selectedTheme, selectedTheme) || other.selectedTheme == selectedTheme)&&(identical(other.followSystemTheme, followSystemTheme) || other.followSystemTheme == followSystemTheme)&&(identical(other.lastUpdated, lastUpdated) || other.lastUpdated == lastUpdated));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,selectedTheme,followSystemTheme,lastUpdated);

@override
String toString() {
  return 'ThemePreferenceModel(selectedTheme: $selectedTheme, followSystemTheme: $followSystemTheme, lastUpdated: $lastUpdated)';
}


}

/// @nodoc
abstract mixin class _$ThemePreferenceModelCopyWith<$Res> implements $ThemePreferenceModelCopyWith<$Res> {
  factory _$ThemePreferenceModelCopyWith(_ThemePreferenceModel value, $Res Function(_ThemePreferenceModel) _then) = __$ThemePreferenceModelCopyWithImpl;
@override @useResult
$Res call({
 AppTheme selectedTheme, bool followSystemTheme, DateTime? lastUpdated
});




}
/// @nodoc
class __$ThemePreferenceModelCopyWithImpl<$Res>
    implements _$ThemePreferenceModelCopyWith<$Res> {
  __$ThemePreferenceModelCopyWithImpl(this._self, this._then);

  final _ThemePreferenceModel _self;
  final $Res Function(_ThemePreferenceModel) _then;

/// Create a copy of ThemePreferenceModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? selectedTheme = null,Object? followSystemTheme = null,Object? lastUpdated = freezed,}) {
  return _then(_ThemePreferenceModel(
selectedTheme: null == selectedTheme ? _self.selectedTheme : selectedTheme // ignore: cast_nullable_to_non_nullable
as AppTheme,followSystemTheme: null == followSystemTheme ? _self.followSystemTheme : followSystemTheme // ignore: cast_nullable_to_non_nullable
as bool,lastUpdated: freezed == lastUpdated ? _self.lastUpdated : lastUpdated // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
