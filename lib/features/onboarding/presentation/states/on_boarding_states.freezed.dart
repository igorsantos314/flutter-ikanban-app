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

 int get currentPage; bool get isLastPage; bool get isOnBoardingCompleted; bool get isLoading; NotificationType get notificationType; String get notificationMessage; bool get showNotification;
/// Create a copy of OnBoardingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OnBoardingStateCopyWith<OnBoardingState> get copyWith => _$OnBoardingStateCopyWithImpl<OnBoardingState>(this as OnBoardingState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OnBoardingState&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.isLastPage, isLastPage) || other.isLastPage == isLastPage)&&(identical(other.isOnBoardingCompleted, isOnBoardingCompleted) || other.isOnBoardingCompleted == isOnBoardingCompleted)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.notificationType, notificationType) || other.notificationType == notificationType)&&(identical(other.notificationMessage, notificationMessage) || other.notificationMessage == notificationMessage)&&(identical(other.showNotification, showNotification) || other.showNotification == showNotification));
}


@override
int get hashCode => Object.hash(runtimeType,currentPage,isLastPage,isOnBoardingCompleted,isLoading,notificationType,notificationMessage,showNotification);

@override
String toString() {
  return 'OnBoardingState(currentPage: $currentPage, isLastPage: $isLastPage, isOnBoardingCompleted: $isOnBoardingCompleted, isLoading: $isLoading, notificationType: $notificationType, notificationMessage: $notificationMessage, showNotification: $showNotification)';
}


}

/// @nodoc
abstract mixin class $OnBoardingStateCopyWith<$Res>  {
  factory $OnBoardingStateCopyWith(OnBoardingState value, $Res Function(OnBoardingState) _then) = _$OnBoardingStateCopyWithImpl;
@useResult
$Res call({
 int currentPage, bool isLastPage, bool isOnBoardingCompleted, bool isLoading, NotificationType notificationType, String notificationMessage, bool showNotification
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
@pragma('vm:prefer-inline') @override $Res call({Object? currentPage = null,Object? isLastPage = null,Object? isOnBoardingCompleted = null,Object? isLoading = null,Object? notificationType = null,Object? notificationMessage = null,Object? showNotification = null,}) {
  return _then(_self.copyWith(
currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,isLastPage: null == isLastPage ? _self.isLastPage : isLastPage // ignore: cast_nullable_to_non_nullable
as bool,isOnBoardingCompleted: null == isOnBoardingCompleted ? _self.isOnBoardingCompleted : isOnBoardingCompleted // ignore: cast_nullable_to_non_nullable
as bool,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,notificationType: null == notificationType ? _self.notificationType : notificationType // ignore: cast_nullable_to_non_nullable
as NotificationType,notificationMessage: null == notificationMessage ? _self.notificationMessage : notificationMessage // ignore: cast_nullable_to_non_nullable
as String,showNotification: null == showNotification ? _self.showNotification : showNotification // ignore: cast_nullable_to_non_nullable
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int currentPage,  bool isLastPage,  bool isOnBoardingCompleted,  bool isLoading,  NotificationType notificationType,  String notificationMessage,  bool showNotification)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnBoardingState() when $default != null:
return $default(_that.currentPage,_that.isLastPage,_that.isOnBoardingCompleted,_that.isLoading,_that.notificationType,_that.notificationMessage,_that.showNotification);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int currentPage,  bool isLastPage,  bool isOnBoardingCompleted,  bool isLoading,  NotificationType notificationType,  String notificationMessage,  bool showNotification)  $default,) {final _that = this;
switch (_that) {
case _OnBoardingState():
return $default(_that.currentPage,_that.isLastPage,_that.isOnBoardingCompleted,_that.isLoading,_that.notificationType,_that.notificationMessage,_that.showNotification);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int currentPage,  bool isLastPage,  bool isOnBoardingCompleted,  bool isLoading,  NotificationType notificationType,  String notificationMessage,  bool showNotification)?  $default,) {final _that = this;
switch (_that) {
case _OnBoardingState() when $default != null:
return $default(_that.currentPage,_that.isLastPage,_that.isOnBoardingCompleted,_that.isLoading,_that.notificationType,_that.notificationMessage,_that.showNotification);case _:
  return null;

}
}

}

/// @nodoc


class _OnBoardingState implements OnBoardingState {
  const _OnBoardingState({this.currentPage = 0, this.isLastPage = false, this.isOnBoardingCompleted = false, this.isLoading = false, this.notificationType = NotificationType.info, this.notificationMessage = "", this.showNotification = false});
  

@override@JsonKey() final  int currentPage;
@override@JsonKey() final  bool isLastPage;
@override@JsonKey() final  bool isOnBoardingCompleted;
@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  NotificationType notificationType;
@override@JsonKey() final  String notificationMessage;
@override@JsonKey() final  bool showNotification;

/// Create a copy of OnBoardingState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnBoardingStateCopyWith<_OnBoardingState> get copyWith => __$OnBoardingStateCopyWithImpl<_OnBoardingState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnBoardingState&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.isLastPage, isLastPage) || other.isLastPage == isLastPage)&&(identical(other.isOnBoardingCompleted, isOnBoardingCompleted) || other.isOnBoardingCompleted == isOnBoardingCompleted)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.notificationType, notificationType) || other.notificationType == notificationType)&&(identical(other.notificationMessage, notificationMessage) || other.notificationMessage == notificationMessage)&&(identical(other.showNotification, showNotification) || other.showNotification == showNotification));
}


@override
int get hashCode => Object.hash(runtimeType,currentPage,isLastPage,isOnBoardingCompleted,isLoading,notificationType,notificationMessage,showNotification);

@override
String toString() {
  return 'OnBoardingState(currentPage: $currentPage, isLastPage: $isLastPage, isOnBoardingCompleted: $isOnBoardingCompleted, isLoading: $isLoading, notificationType: $notificationType, notificationMessage: $notificationMessage, showNotification: $showNotification)';
}


}

/// @nodoc
abstract mixin class _$OnBoardingStateCopyWith<$Res> implements $OnBoardingStateCopyWith<$Res> {
  factory _$OnBoardingStateCopyWith(_OnBoardingState value, $Res Function(_OnBoardingState) _then) = __$OnBoardingStateCopyWithImpl;
@override @useResult
$Res call({
 int currentPage, bool isLastPage, bool isOnBoardingCompleted, bool isLoading, NotificationType notificationType, String notificationMessage, bool showNotification
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
@override @pragma('vm:prefer-inline') $Res call({Object? currentPage = null,Object? isLastPage = null,Object? isOnBoardingCompleted = null,Object? isLoading = null,Object? notificationType = null,Object? notificationMessage = null,Object? showNotification = null,}) {
  return _then(_OnBoardingState(
currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,isLastPage: null == isLastPage ? _self.isLastPage : isLastPage // ignore: cast_nullable_to_non_nullable
as bool,isOnBoardingCompleted: null == isOnBoardingCompleted ? _self.isOnBoardingCompleted : isOnBoardingCompleted // ignore: cast_nullable_to_non_nullable
as bool,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,notificationType: null == notificationType ? _self.notificationType : notificationType // ignore: cast_nullable_to_non_nullable
as NotificationType,notificationMessage: null == notificationMessage ? _self.notificationMessage : notificationMessage // ignore: cast_nullable_to_non_nullable
as String,showNotification: null == showNotification ? _self.showNotification : showNotification // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
