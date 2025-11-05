// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'on_boarding_states.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OnBoardingState {

 bool get isOnBoardingCompleted; bool get isLoading;
/// Create a copy of OnBoardingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OnBoardingStateCopyWith<OnBoardingState> get copyWith => _$OnBoardingStateCopyWithImpl<OnBoardingState>(this as OnBoardingState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OnBoardingState&&(identical(other.isOnBoardingCompleted, isOnBoardingCompleted) || other.isOnBoardingCompleted == isOnBoardingCompleted)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading));
}


@override
int get hashCode => Object.hash(runtimeType,isOnBoardingCompleted,isLoading);

@override
String toString() {
  return 'OnBoardingState(isOnBoardingCompleted: $isOnBoardingCompleted, isLoading: $isLoading)';
}


}

/// @nodoc
abstract mixin class $OnBoardingStateCopyWith<$Res>  {
  factory $OnBoardingStateCopyWith(OnBoardingState value, $Res Function(OnBoardingState) _then) = _$OnBoardingStateCopyWithImpl;
@useResult
$Res call({
 bool isOnBoardingCompleted, bool isLoading
});




}
/// @nodoc
class _$OnBoardingStateCopyWithImpl<$Res>
    implements $OnBoardingStateCopyWith<$Res> {
  _$OnBoardingStateCopyWithImpl(this._self, this._then);

  final OnBoardingState _self;
  final $Res Function(OnBoardingState) _then;

/// Create a copy of OnBoardingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isOnBoardingCompleted = null,Object? isLoading = null,}) {
  return _then(_self.copyWith(
isOnBoardingCompleted: null == isOnBoardingCompleted ? _self.isOnBoardingCompleted : isOnBoardingCompleted // ignore: cast_nullable_to_non_nullable
as bool,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [OnBoardingState].
extension OnBoardingStatePatterns on OnBoardingState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OnBoardingState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OnBoardingState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OnBoardingState value)  $default,){
final _that = this;
switch (_that) {
case _OnBoardingState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OnBoardingState value)?  $default,){
final _that = this;
switch (_that) {
case _OnBoardingState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isOnBoardingCompleted,  bool isLoading)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnBoardingState() when $default != null:
return $default(_that.isOnBoardingCompleted,_that.isLoading);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isOnBoardingCompleted,  bool isLoading)  $default,) {final _that = this;
switch (_that) {
case _OnBoardingState():
return $default(_that.isOnBoardingCompleted,_that.isLoading);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isOnBoardingCompleted,  bool isLoading)?  $default,) {final _that = this;
switch (_that) {
case _OnBoardingState() when $default != null:
return $default(_that.isOnBoardingCompleted,_that.isLoading);case _:
  return null;

}
}

}

/// @nodoc


class _OnBoardingState implements OnBoardingState {
  const _OnBoardingState({this.isOnBoardingCompleted = false, this.isLoading = false});
  

@override@JsonKey() final  bool isOnBoardingCompleted;
@override@JsonKey() final  bool isLoading;

/// Create a copy of OnBoardingState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnBoardingStateCopyWith<_OnBoardingState> get copyWith => __$OnBoardingStateCopyWithImpl<_OnBoardingState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnBoardingState&&(identical(other.isOnBoardingCompleted, isOnBoardingCompleted) || other.isOnBoardingCompleted == isOnBoardingCompleted)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading));
}


@override
int get hashCode => Object.hash(runtimeType,isOnBoardingCompleted,isLoading);

@override
String toString() {
  return 'OnBoardingState(isOnBoardingCompleted: $isOnBoardingCompleted, isLoading: $isLoading)';
}


}

/// @nodoc
abstract mixin class _$OnBoardingStateCopyWith<$Res> implements $OnBoardingStateCopyWith<$Res> {
  factory _$OnBoardingStateCopyWith(_OnBoardingState value, $Res Function(_OnBoardingState) _then) = __$OnBoardingStateCopyWithImpl;
@override @useResult
$Res call({
 bool isOnBoardingCompleted, bool isLoading
});




}
/// @nodoc
class __$OnBoardingStateCopyWithImpl<$Res>
    implements _$OnBoardingStateCopyWith<$Res> {
  __$OnBoardingStateCopyWithImpl(this._self, this._then);

  final _OnBoardingState _self;
  final $Res Function(_OnBoardingState) _then;

/// Create a copy of OnBoardingState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isOnBoardingCompleted = null,Object? isLoading = null,}) {
  return _then(_OnBoardingState(
isOnBoardingCompleted: null == isOnBoardingCompleted ? _self.isOnBoardingCompleted : isOnBoardingCompleted // ignore: cast_nullable_to_non_nullable
as bool,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
