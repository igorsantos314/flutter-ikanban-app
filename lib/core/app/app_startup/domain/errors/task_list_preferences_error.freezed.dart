// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_list_preferences_error.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TaskListPreferencesError {

 String? get message; Object? get throwable;
/// Create a copy of TaskListPreferencesError
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskListPreferencesErrorCopyWith<TaskListPreferencesError> get copyWith => _$TaskListPreferencesErrorCopyWithImpl<TaskListPreferencesError>(this as TaskListPreferencesError, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskListPreferencesError&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other.throwable, throwable));
}


@override
int get hashCode => Object.hash(runtimeType,message,const DeepCollectionEquality().hash(throwable));

@override
String toString() {
  return 'TaskListPreferencesError(message: $message, throwable: $throwable)';
}


}

/// @nodoc
abstract mixin class $TaskListPreferencesErrorCopyWith<$Res>  {
  factory $TaskListPreferencesErrorCopyWith(TaskListPreferencesError value, $Res Function(TaskListPreferencesError) _then) = _$TaskListPreferencesErrorCopyWithImpl;
@useResult
$Res call({
 String? message, Object? throwable
});




}
/// @nodoc
class _$TaskListPreferencesErrorCopyWithImpl<$Res>
    implements $TaskListPreferencesErrorCopyWith<$Res> {
  _$TaskListPreferencesErrorCopyWithImpl(this._self, this._then);

  final TaskListPreferencesError _self;
  final $Res Function(TaskListPreferencesError) _then;

/// Create a copy of TaskListPreferencesError
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? message = freezed,Object? throwable = freezed,}) {
  return _then(_self.copyWith(
message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,throwable: freezed == throwable ? _self.throwable : throwable ,
  ));
}

}


/// Adds pattern-matching-related methods to [TaskListPreferencesError].
extension TaskListPreferencesErrorPatterns on TaskListPreferencesError {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _NotFound value)?  notFound,TResult Function( _DatabaseError value)?  databaseError,TResult Function( _ValidationError value)?  validationError,TResult Function( _NetworkError value)?  networkError,TResult Function( _GenericError value)?  genericError,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotFound() when notFound != null:
return notFound(_that);case _DatabaseError() when databaseError != null:
return databaseError(_that);case _ValidationError() when validationError != null:
return validationError(_that);case _NetworkError() when networkError != null:
return networkError(_that);case _GenericError() when genericError != null:
return genericError(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _NotFound value)  notFound,required TResult Function( _DatabaseError value)  databaseError,required TResult Function( _ValidationError value)  validationError,required TResult Function( _NetworkError value)  networkError,required TResult Function( _GenericError value)  genericError,}){
final _that = this;
switch (_that) {
case _NotFound():
return notFound(_that);case _DatabaseError():
return databaseError(_that);case _ValidationError():
return validationError(_that);case _NetworkError():
return networkError(_that);case _GenericError():
return genericError(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _NotFound value)?  notFound,TResult? Function( _DatabaseError value)?  databaseError,TResult? Function( _ValidationError value)?  validationError,TResult? Function( _NetworkError value)?  networkError,TResult? Function( _GenericError value)?  genericError,}){
final _that = this;
switch (_that) {
case _NotFound() when notFound != null:
return notFound(_that);case _DatabaseError() when databaseError != null:
return databaseError(_that);case _ValidationError() when validationError != null:
return validationError(_that);case _NetworkError() when networkError != null:
return networkError(_that);case _GenericError() when genericError != null:
return genericError(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String? message,  Object? throwable)?  notFound,TResult Function( String? message,  Object? throwable)?  databaseError,TResult Function( String? message,  Object? throwable)?  validationError,TResult Function( String? message,  Object? throwable)?  networkError,TResult Function( String? message,  Object? throwable)?  genericError,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotFound() when notFound != null:
return notFound(_that.message,_that.throwable);case _DatabaseError() when databaseError != null:
return databaseError(_that.message,_that.throwable);case _ValidationError() when validationError != null:
return validationError(_that.message,_that.throwable);case _NetworkError() when networkError != null:
return networkError(_that.message,_that.throwable);case _GenericError() when genericError != null:
return genericError(_that.message,_that.throwable);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String? message,  Object? throwable)  notFound,required TResult Function( String? message,  Object? throwable)  databaseError,required TResult Function( String? message,  Object? throwable)  validationError,required TResult Function( String? message,  Object? throwable)  networkError,required TResult Function( String? message,  Object? throwable)  genericError,}) {final _that = this;
switch (_that) {
case _NotFound():
return notFound(_that.message,_that.throwable);case _DatabaseError():
return databaseError(_that.message,_that.throwable);case _ValidationError():
return validationError(_that.message,_that.throwable);case _NetworkError():
return networkError(_that.message,_that.throwable);case _GenericError():
return genericError(_that.message,_that.throwable);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String? message,  Object? throwable)?  notFound,TResult? Function( String? message,  Object? throwable)?  databaseError,TResult? Function( String? message,  Object? throwable)?  validationError,TResult? Function( String? message,  Object? throwable)?  networkError,TResult? Function( String? message,  Object? throwable)?  genericError,}) {final _that = this;
switch (_that) {
case _NotFound() when notFound != null:
return notFound(_that.message,_that.throwable);case _DatabaseError() when databaseError != null:
return databaseError(_that.message,_that.throwable);case _ValidationError() when validationError != null:
return validationError(_that.message,_that.throwable);case _NetworkError() when networkError != null:
return networkError(_that.message,_that.throwable);case _GenericError() when genericError != null:
return genericError(_that.message,_that.throwable);case _:
  return null;

}
}

}

/// @nodoc


class _NotFound implements TaskListPreferencesError {
  const _NotFound({this.message, this.throwable});
  

@override final  String? message;
@override final  Object? throwable;

/// Create a copy of TaskListPreferencesError
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotFoundCopyWith<_NotFound> get copyWith => __$NotFoundCopyWithImpl<_NotFound>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotFound&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other.throwable, throwable));
}


@override
int get hashCode => Object.hash(runtimeType,message,const DeepCollectionEquality().hash(throwable));

@override
String toString() {
  return 'TaskListPreferencesError.notFound(message: $message, throwable: $throwable)';
}


}

/// @nodoc
abstract mixin class _$NotFoundCopyWith<$Res> implements $TaskListPreferencesErrorCopyWith<$Res> {
  factory _$NotFoundCopyWith(_NotFound value, $Res Function(_NotFound) _then) = __$NotFoundCopyWithImpl;
@override @useResult
$Res call({
 String? message, Object? throwable
});




}
/// @nodoc
class __$NotFoundCopyWithImpl<$Res>
    implements _$NotFoundCopyWith<$Res> {
  __$NotFoundCopyWithImpl(this._self, this._then);

  final _NotFound _self;
  final $Res Function(_NotFound) _then;

/// Create a copy of TaskListPreferencesError
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = freezed,Object? throwable = freezed,}) {
  return _then(_NotFound(
message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,throwable: freezed == throwable ? _self.throwable : throwable ,
  ));
}


}

/// @nodoc


class _DatabaseError implements TaskListPreferencesError {
  const _DatabaseError({this.message, this.throwable});
  

@override final  String? message;
@override final  Object? throwable;

/// Create a copy of TaskListPreferencesError
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DatabaseErrorCopyWith<_DatabaseError> get copyWith => __$DatabaseErrorCopyWithImpl<_DatabaseError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DatabaseError&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other.throwable, throwable));
}


@override
int get hashCode => Object.hash(runtimeType,message,const DeepCollectionEquality().hash(throwable));

@override
String toString() {
  return 'TaskListPreferencesError.databaseError(message: $message, throwable: $throwable)';
}


}

/// @nodoc
abstract mixin class _$DatabaseErrorCopyWith<$Res> implements $TaskListPreferencesErrorCopyWith<$Res> {
  factory _$DatabaseErrorCopyWith(_DatabaseError value, $Res Function(_DatabaseError) _then) = __$DatabaseErrorCopyWithImpl;
@override @useResult
$Res call({
 String? message, Object? throwable
});




}
/// @nodoc
class __$DatabaseErrorCopyWithImpl<$Res>
    implements _$DatabaseErrorCopyWith<$Res> {
  __$DatabaseErrorCopyWithImpl(this._self, this._then);

  final _DatabaseError _self;
  final $Res Function(_DatabaseError) _then;

/// Create a copy of TaskListPreferencesError
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = freezed,Object? throwable = freezed,}) {
  return _then(_DatabaseError(
message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,throwable: freezed == throwable ? _self.throwable : throwable ,
  ));
}


}

/// @nodoc


class _ValidationError implements TaskListPreferencesError {
  const _ValidationError({this.message, this.throwable});
  

@override final  String? message;
@override final  Object? throwable;

/// Create a copy of TaskListPreferencesError
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ValidationErrorCopyWith<_ValidationError> get copyWith => __$ValidationErrorCopyWithImpl<_ValidationError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ValidationError&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other.throwable, throwable));
}


@override
int get hashCode => Object.hash(runtimeType,message,const DeepCollectionEquality().hash(throwable));

@override
String toString() {
  return 'TaskListPreferencesError.validationError(message: $message, throwable: $throwable)';
}


}

/// @nodoc
abstract mixin class _$ValidationErrorCopyWith<$Res> implements $TaskListPreferencesErrorCopyWith<$Res> {
  factory _$ValidationErrorCopyWith(_ValidationError value, $Res Function(_ValidationError) _then) = __$ValidationErrorCopyWithImpl;
@override @useResult
$Res call({
 String? message, Object? throwable
});




}
/// @nodoc
class __$ValidationErrorCopyWithImpl<$Res>
    implements _$ValidationErrorCopyWith<$Res> {
  __$ValidationErrorCopyWithImpl(this._self, this._then);

  final _ValidationError _self;
  final $Res Function(_ValidationError) _then;

/// Create a copy of TaskListPreferencesError
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = freezed,Object? throwable = freezed,}) {
  return _then(_ValidationError(
message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,throwable: freezed == throwable ? _self.throwable : throwable ,
  ));
}


}

/// @nodoc


class _NetworkError implements TaskListPreferencesError {
  const _NetworkError({this.message, this.throwable});
  

@override final  String? message;
@override final  Object? throwable;

/// Create a copy of TaskListPreferencesError
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NetworkErrorCopyWith<_NetworkError> get copyWith => __$NetworkErrorCopyWithImpl<_NetworkError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NetworkError&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other.throwable, throwable));
}


@override
int get hashCode => Object.hash(runtimeType,message,const DeepCollectionEquality().hash(throwable));

@override
String toString() {
  return 'TaskListPreferencesError.networkError(message: $message, throwable: $throwable)';
}


}

/// @nodoc
abstract mixin class _$NetworkErrorCopyWith<$Res> implements $TaskListPreferencesErrorCopyWith<$Res> {
  factory _$NetworkErrorCopyWith(_NetworkError value, $Res Function(_NetworkError) _then) = __$NetworkErrorCopyWithImpl;
@override @useResult
$Res call({
 String? message, Object? throwable
});




}
/// @nodoc
class __$NetworkErrorCopyWithImpl<$Res>
    implements _$NetworkErrorCopyWith<$Res> {
  __$NetworkErrorCopyWithImpl(this._self, this._then);

  final _NetworkError _self;
  final $Res Function(_NetworkError) _then;

/// Create a copy of TaskListPreferencesError
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = freezed,Object? throwable = freezed,}) {
  return _then(_NetworkError(
message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,throwable: freezed == throwable ? _self.throwable : throwable ,
  ));
}


}

/// @nodoc


class _GenericError implements TaskListPreferencesError {
  const _GenericError({this.message, this.throwable});
  

@override final  String? message;
@override final  Object? throwable;

/// Create a copy of TaskListPreferencesError
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GenericErrorCopyWith<_GenericError> get copyWith => __$GenericErrorCopyWithImpl<_GenericError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GenericError&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other.throwable, throwable));
}


@override
int get hashCode => Object.hash(runtimeType,message,const DeepCollectionEquality().hash(throwable));

@override
String toString() {
  return 'TaskListPreferencesError.genericError(message: $message, throwable: $throwable)';
}


}

/// @nodoc
abstract mixin class _$GenericErrorCopyWith<$Res> implements $TaskListPreferencesErrorCopyWith<$Res> {
  factory _$GenericErrorCopyWith(_GenericError value, $Res Function(_GenericError) _then) = __$GenericErrorCopyWithImpl;
@override @useResult
$Res call({
 String? message, Object? throwable
});




}
/// @nodoc
class __$GenericErrorCopyWithImpl<$Res>
    implements _$GenericErrorCopyWith<$Res> {
  __$GenericErrorCopyWithImpl(this._self, this._then);

  final _GenericError _self;
  final $Res Function(_GenericError) _then;

/// Create a copy of TaskListPreferencesError
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = freezed,Object? throwable = freezed,}) {
  return _then(_GenericError(
message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,throwable: freezed == throwable ? _self.throwable : throwable ,
  ));
}


}

// dart format on
