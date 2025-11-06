// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_startup_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AppStartupState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppStartupState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AppStartupState()';
}


}

/// @nodoc
class $AppStartupStateCopyWith<$Res>  {
$AppStartupStateCopyWith(AppStartupState _, $Res Function(AppStartupState) __);
}


/// Adds pattern-matching-related methods to [AppStartupState].
extension AppStartupStatePatterns on AppStartupState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _AppStartupStateInitial value)?  initial,TResult Function( _AppStartupStateLoading value)?  loading,TResult Function( _AppStartupStateLoaded value)?  loaded,TResult Function( _AppStartupStateError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppStartupStateInitial() when initial != null:
return initial(_that);case _AppStartupStateLoading() when loading != null:
return loading(_that);case _AppStartupStateLoaded() when loaded != null:
return loaded(_that);case _AppStartupStateError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _AppStartupStateInitial value)  initial,required TResult Function( _AppStartupStateLoading value)  loading,required TResult Function( _AppStartupStateLoaded value)  loaded,required TResult Function( _AppStartupStateError value)  error,}){
final _that = this;
switch (_that) {
case _AppStartupStateInitial():
return initial(_that);case _AppStartupStateLoading():
return loading(_that);case _AppStartupStateLoaded():
return loaded(_that);case _AppStartupStateError():
return error(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _AppStartupStateInitial value)?  initial,TResult? Function( _AppStartupStateLoading value)?  loading,TResult? Function( _AppStartupStateLoaded value)?  loaded,TResult? Function( _AppStartupStateError value)?  error,}){
final _that = this;
switch (_that) {
case _AppStartupStateInitial() when initial != null:
return initial(_that);case _AppStartupStateLoading() when loading != null:
return loading(_that);case _AppStartupStateLoaded() when loaded != null:
return loaded(_that);case _AppStartupStateError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( bool isOnboardingComplete)?  loaded,TResult Function( String? message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppStartupStateInitial() when initial != null:
return initial();case _AppStartupStateLoading() when loading != null:
return loading();case _AppStartupStateLoaded() when loaded != null:
return loaded(_that.isOnboardingComplete);case _AppStartupStateError() when error != null:
return error(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( bool isOnboardingComplete)  loaded,required TResult Function( String? message)  error,}) {final _that = this;
switch (_that) {
case _AppStartupStateInitial():
return initial();case _AppStartupStateLoading():
return loading();case _AppStartupStateLoaded():
return loaded(_that.isOnboardingComplete);case _AppStartupStateError():
return error(_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( bool isOnboardingComplete)?  loaded,TResult? Function( String? message)?  error,}) {final _that = this;
switch (_that) {
case _AppStartupStateInitial() when initial != null:
return initial();case _AppStartupStateLoading() when loading != null:
return loading();case _AppStartupStateLoaded() when loaded != null:
return loaded(_that.isOnboardingComplete);case _AppStartupStateError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _AppStartupStateInitial implements AppStartupState {
  const _AppStartupStateInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppStartupStateInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AppStartupState.initial()';
}


}




/// @nodoc


class _AppStartupStateLoading implements AppStartupState {
  const _AppStartupStateLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppStartupStateLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AppStartupState.loading()';
}


}




/// @nodoc


class _AppStartupStateLoaded implements AppStartupState {
  const _AppStartupStateLoaded({required this.isOnboardingComplete});
  

 final  bool isOnboardingComplete;

/// Create a copy of AppStartupState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppStartupStateLoadedCopyWith<_AppStartupStateLoaded> get copyWith => __$AppStartupStateLoadedCopyWithImpl<_AppStartupStateLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppStartupStateLoaded&&(identical(other.isOnboardingComplete, isOnboardingComplete) || other.isOnboardingComplete == isOnboardingComplete));
}


@override
int get hashCode => Object.hash(runtimeType,isOnboardingComplete);

@override
String toString() {
  return 'AppStartupState.loaded(isOnboardingComplete: $isOnboardingComplete)';
}


}

/// @nodoc
abstract mixin class _$AppStartupStateLoadedCopyWith<$Res> implements $AppStartupStateCopyWith<$Res> {
  factory _$AppStartupStateLoadedCopyWith(_AppStartupStateLoaded value, $Res Function(_AppStartupStateLoaded) _then) = __$AppStartupStateLoadedCopyWithImpl;
@useResult
$Res call({
 bool isOnboardingComplete
});




}
/// @nodoc
class __$AppStartupStateLoadedCopyWithImpl<$Res>
    implements _$AppStartupStateLoadedCopyWith<$Res> {
  __$AppStartupStateLoadedCopyWithImpl(this._self, this._then);

  final _AppStartupStateLoaded _self;
  final $Res Function(_AppStartupStateLoaded) _then;

/// Create a copy of AppStartupState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? isOnboardingComplete = null,}) {
  return _then(_AppStartupStateLoaded(
isOnboardingComplete: null == isOnboardingComplete ? _self.isOnboardingComplete : isOnboardingComplete // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class _AppStartupStateError implements AppStartupState {
  const _AppStartupStateError({this.message});
  

 final  String? message;

/// Create a copy of AppStartupState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppStartupStateErrorCopyWith<_AppStartupStateError> get copyWith => __$AppStartupStateErrorCopyWithImpl<_AppStartupStateError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppStartupStateError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'AppStartupState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class _$AppStartupStateErrorCopyWith<$Res> implements $AppStartupStateCopyWith<$Res> {
  factory _$AppStartupStateErrorCopyWith(_AppStartupStateError value, $Res Function(_AppStartupStateError) _then) = __$AppStartupStateErrorCopyWithImpl;
@useResult
$Res call({
 String? message
});




}
/// @nodoc
class __$AppStartupStateErrorCopyWithImpl<$Res>
    implements _$AppStartupStateErrorCopyWith<$Res> {
  __$AppStartupStateErrorCopyWithImpl(this._self, this._then);

  final _AppStartupStateError _self;
  final $Res Function(_AppStartupStateError) _then;

/// Create a copy of AppStartupState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = freezed,}) {
  return _then(_AppStartupStateError(
message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
