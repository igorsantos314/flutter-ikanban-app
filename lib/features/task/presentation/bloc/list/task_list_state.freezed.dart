// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_list_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TaskListState {

 String get searchQuery; List<TaskModel> get tasks; bool get isLoading; String? get errorMessage;
/// Create a copy of TaskListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskListStateCopyWith<TaskListState> get copyWith => _$TaskListStateCopyWithImpl<TaskListState>(this as TaskListState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskListState&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&const DeepCollectionEquality().equals(other.tasks, tasks)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,searchQuery,const DeepCollectionEquality().hash(tasks),isLoading,errorMessage);

@override
String toString() {
  return 'TaskListState(searchQuery: $searchQuery, tasks: $tasks, isLoading: $isLoading, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $TaskListStateCopyWith<$Res>  {
  factory $TaskListStateCopyWith(TaskListState value, $Res Function(TaskListState) _then) = _$TaskListStateCopyWithImpl;
@useResult
$Res call({
 String searchQuery, List<TaskModel> tasks, bool isLoading, String? errorMessage
});




}
/// @nodoc
class _$TaskListStateCopyWithImpl<$Res>
    implements $TaskListStateCopyWith<$Res> {
  _$TaskListStateCopyWithImpl(this._self, this._then);

  final TaskListState _self;
  final $Res Function(TaskListState) _then;

/// Create a copy of TaskListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? searchQuery = null,Object? tasks = null,Object? isLoading = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,tasks: null == tasks ? _self.tasks : tasks // ignore: cast_nullable_to_non_nullable
as List<TaskModel>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TaskListState].
extension TaskListStatePatterns on TaskListState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaskListState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaskListState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaskListState value)  $default,){
final _that = this;
switch (_that) {
case _TaskListState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaskListState value)?  $default,){
final _that = this;
switch (_that) {
case _TaskListState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String searchQuery,  List<TaskModel> tasks,  bool isLoading,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaskListState() when $default != null:
return $default(_that.searchQuery,_that.tasks,_that.isLoading,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String searchQuery,  List<TaskModel> tasks,  bool isLoading,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _TaskListState():
return $default(_that.searchQuery,_that.tasks,_that.isLoading,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String searchQuery,  List<TaskModel> tasks,  bool isLoading,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _TaskListState() when $default != null:
return $default(_that.searchQuery,_that.tasks,_that.isLoading,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _TaskListState implements TaskListState {
  const _TaskListState({this.searchQuery = "", final  List<TaskModel> tasks = const [], this.isLoading = false, this.errorMessage}): _tasks = tasks;
  

@override@JsonKey() final  String searchQuery;
 final  List<TaskModel> _tasks;
@override@JsonKey() List<TaskModel> get tasks {
  if (_tasks is EqualUnmodifiableListView) return _tasks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tasks);
}

@override@JsonKey() final  bool isLoading;
@override final  String? errorMessage;

/// Create a copy of TaskListState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskListStateCopyWith<_TaskListState> get copyWith => __$TaskListStateCopyWithImpl<_TaskListState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskListState&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&const DeepCollectionEquality().equals(other._tasks, _tasks)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,searchQuery,const DeepCollectionEquality().hash(_tasks),isLoading,errorMessage);

@override
String toString() {
  return 'TaskListState(searchQuery: $searchQuery, tasks: $tasks, isLoading: $isLoading, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$TaskListStateCopyWith<$Res> implements $TaskListStateCopyWith<$Res> {
  factory _$TaskListStateCopyWith(_TaskListState value, $Res Function(_TaskListState) _then) = __$TaskListStateCopyWithImpl;
@override @useResult
$Res call({
 String searchQuery, List<TaskModel> tasks, bool isLoading, String? errorMessage
});




}
/// @nodoc
class __$TaskListStateCopyWithImpl<$Res>
    implements _$TaskListStateCopyWith<$Res> {
  __$TaskListStateCopyWithImpl(this._self, this._then);

  final _TaskListState _self;
  final $Res Function(_TaskListState) _then;

/// Create a copy of TaskListState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? searchQuery = null,Object? tasks = null,Object? isLoading = null,Object? errorMessage = freezed,}) {
  return _then(_TaskListState(
searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,tasks: null == tasks ? _self._tasks : tasks // ignore: cast_nullable_to_non_nullable
as List<TaskModel>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
