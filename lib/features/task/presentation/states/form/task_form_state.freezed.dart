// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_form_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TaskFormState {

 int? get taskId; String get title; String? get titleError; String get description; String? get descriptionError; TaskStatus get status; TaskPriority get priority; DateTime? get dueDate; TaskComplexity get complexity; TaskType get type; TaskColors get color; bool get showNotification; NotificationType get notificationType; String get notificationMessage; bool get closeScreen; bool get isLoading; String? get errorMessage;
/// Create a copy of TaskFormState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskFormStateCopyWith<TaskFormState> get copyWith => _$TaskFormStateCopyWithImpl<TaskFormState>(this as TaskFormState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskFormState&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.title, title) || other.title == title)&&(identical(other.titleError, titleError) || other.titleError == titleError)&&(identical(other.description, description) || other.description == description)&&(identical(other.descriptionError, descriptionError) || other.descriptionError == descriptionError)&&(identical(other.status, status) || other.status == status)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.complexity, complexity) || other.complexity == complexity)&&(identical(other.type, type) || other.type == type)&&(identical(other.color, color) || other.color == color)&&(identical(other.showNotification, showNotification) || other.showNotification == showNotification)&&(identical(other.notificationType, notificationType) || other.notificationType == notificationType)&&(identical(other.notificationMessage, notificationMessage) || other.notificationMessage == notificationMessage)&&(identical(other.closeScreen, closeScreen) || other.closeScreen == closeScreen)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,taskId,title,titleError,description,descriptionError,status,priority,dueDate,complexity,type,color,showNotification,notificationType,notificationMessage,closeScreen,isLoading,errorMessage);

@override
String toString() {
  return 'TaskFormState(taskId: $taskId, title: $title, titleError: $titleError, description: $description, descriptionError: $descriptionError, status: $status, priority: $priority, dueDate: $dueDate, complexity: $complexity, type: $type, color: $color, showNotification: $showNotification, notificationType: $notificationType, notificationMessage: $notificationMessage, closeScreen: $closeScreen, isLoading: $isLoading, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $TaskFormStateCopyWith<$Res>  {
  factory $TaskFormStateCopyWith(TaskFormState value, $Res Function(TaskFormState) _then) = _$TaskFormStateCopyWithImpl;
@useResult
$Res call({
 int? taskId, String title, String? titleError, String description, String? descriptionError, TaskStatus status, TaskPriority priority, DateTime? dueDate, TaskComplexity complexity, TaskType type, TaskColors color, bool showNotification, NotificationType notificationType, String notificationMessage, bool closeScreen, bool isLoading, String? errorMessage
});




}
/// @nodoc
class _$TaskFormStateCopyWithImpl<$Res>
    implements $TaskFormStateCopyWith<$Res> {
  _$TaskFormStateCopyWithImpl(this._self, this._then);

  final TaskFormState _self;
  final $Res Function(TaskFormState) _then;

/// Create a copy of TaskFormState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? taskId = freezed,Object? title = null,Object? titleError = freezed,Object? description = null,Object? descriptionError = freezed,Object? status = null,Object? priority = null,Object? dueDate = freezed,Object? complexity = null,Object? type = null,Object? color = null,Object? showNotification = null,Object? notificationType = null,Object? notificationMessage = null,Object? closeScreen = null,Object? isLoading = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
taskId: freezed == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as int?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,titleError: freezed == titleError ? _self.titleError : titleError // ignore: cast_nullable_to_non_nullable
as String?,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,descriptionError: freezed == descriptionError ? _self.descriptionError : descriptionError // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TaskStatus,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as TaskPriority,dueDate: freezed == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,complexity: null == complexity ? _self.complexity : complexity // ignore: cast_nullable_to_non_nullable
as TaskComplexity,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TaskType,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as TaskColors,showNotification: null == showNotification ? _self.showNotification : showNotification // ignore: cast_nullable_to_non_nullable
as bool,notificationType: null == notificationType ? _self.notificationType : notificationType // ignore: cast_nullable_to_non_nullable
as NotificationType,notificationMessage: null == notificationMessage ? _self.notificationMessage : notificationMessage // ignore: cast_nullable_to_non_nullable
as String,closeScreen: null == closeScreen ? _self.closeScreen : closeScreen // ignore: cast_nullable_to_non_nullable
as bool,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TaskFormState].
extension TaskFormStatePatterns on TaskFormState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaskFormState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaskFormState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaskFormState value)  $default,){
final _that = this;
switch (_that) {
case _TaskFormState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaskFormState value)?  $default,){
final _that = this;
switch (_that) {
case _TaskFormState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? taskId,  String title,  String? titleError,  String description,  String? descriptionError,  TaskStatus status,  TaskPriority priority,  DateTime? dueDate,  TaskComplexity complexity,  TaskType type,  TaskColors color,  bool showNotification,  NotificationType notificationType,  String notificationMessage,  bool closeScreen,  bool isLoading,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaskFormState() when $default != null:
return $default(_that.taskId,_that.title,_that.titleError,_that.description,_that.descriptionError,_that.status,_that.priority,_that.dueDate,_that.complexity,_that.type,_that.color,_that.showNotification,_that.notificationType,_that.notificationMessage,_that.closeScreen,_that.isLoading,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? taskId,  String title,  String? titleError,  String description,  String? descriptionError,  TaskStatus status,  TaskPriority priority,  DateTime? dueDate,  TaskComplexity complexity,  TaskType type,  TaskColors color,  bool showNotification,  NotificationType notificationType,  String notificationMessage,  bool closeScreen,  bool isLoading,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _TaskFormState():
return $default(_that.taskId,_that.title,_that.titleError,_that.description,_that.descriptionError,_that.status,_that.priority,_that.dueDate,_that.complexity,_that.type,_that.color,_that.showNotification,_that.notificationType,_that.notificationMessage,_that.closeScreen,_that.isLoading,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? taskId,  String title,  String? titleError,  String description,  String? descriptionError,  TaskStatus status,  TaskPriority priority,  DateTime? dueDate,  TaskComplexity complexity,  TaskType type,  TaskColors color,  bool showNotification,  NotificationType notificationType,  String notificationMessage,  bool closeScreen,  bool isLoading,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _TaskFormState() when $default != null:
return $default(_that.taskId,_that.title,_that.titleError,_that.description,_that.descriptionError,_that.status,_that.priority,_that.dueDate,_that.complexity,_that.type,_that.color,_that.showNotification,_that.notificationType,_that.notificationMessage,_that.closeScreen,_that.isLoading,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _TaskFormState implements TaskFormState {
  const _TaskFormState({this.taskId, this.title = "", this.titleError = null, this.description = "", this.descriptionError = null, this.status = TaskStatus.backlog, this.priority = TaskPriority.low, this.dueDate, this.complexity = TaskComplexity.easy, this.type = TaskType.personal, this.color = TaskColors.defaultColor, this.showNotification = false, this.notificationType = NotificationType.info, this.notificationMessage = "", this.closeScreen = false, this.isLoading = false, this.errorMessage});
  

@override final  int? taskId;
@override@JsonKey() final  String title;
@override@JsonKey() final  String? titleError;
@override@JsonKey() final  String description;
@override@JsonKey() final  String? descriptionError;
@override@JsonKey() final  TaskStatus status;
@override@JsonKey() final  TaskPriority priority;
@override final  DateTime? dueDate;
@override@JsonKey() final  TaskComplexity complexity;
@override@JsonKey() final  TaskType type;
@override@JsonKey() final  TaskColors color;
@override@JsonKey() final  bool showNotification;
@override@JsonKey() final  NotificationType notificationType;
@override@JsonKey() final  String notificationMessage;
@override@JsonKey() final  bool closeScreen;
@override@JsonKey() final  bool isLoading;
@override final  String? errorMessage;

/// Create a copy of TaskFormState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskFormStateCopyWith<_TaskFormState> get copyWith => __$TaskFormStateCopyWithImpl<_TaskFormState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskFormState&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.title, title) || other.title == title)&&(identical(other.titleError, titleError) || other.titleError == titleError)&&(identical(other.description, description) || other.description == description)&&(identical(other.descriptionError, descriptionError) || other.descriptionError == descriptionError)&&(identical(other.status, status) || other.status == status)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.complexity, complexity) || other.complexity == complexity)&&(identical(other.type, type) || other.type == type)&&(identical(other.color, color) || other.color == color)&&(identical(other.showNotification, showNotification) || other.showNotification == showNotification)&&(identical(other.notificationType, notificationType) || other.notificationType == notificationType)&&(identical(other.notificationMessage, notificationMessage) || other.notificationMessage == notificationMessage)&&(identical(other.closeScreen, closeScreen) || other.closeScreen == closeScreen)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,taskId,title,titleError,description,descriptionError,status,priority,dueDate,complexity,type,color,showNotification,notificationType,notificationMessage,closeScreen,isLoading,errorMessage);

@override
String toString() {
  return 'TaskFormState(taskId: $taskId, title: $title, titleError: $titleError, description: $description, descriptionError: $descriptionError, status: $status, priority: $priority, dueDate: $dueDate, complexity: $complexity, type: $type, color: $color, showNotification: $showNotification, notificationType: $notificationType, notificationMessage: $notificationMessage, closeScreen: $closeScreen, isLoading: $isLoading, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$TaskFormStateCopyWith<$Res> implements $TaskFormStateCopyWith<$Res> {
  factory _$TaskFormStateCopyWith(_TaskFormState value, $Res Function(_TaskFormState) _then) = __$TaskFormStateCopyWithImpl;
@override @useResult
$Res call({
 int? taskId, String title, String? titleError, String description, String? descriptionError, TaskStatus status, TaskPriority priority, DateTime? dueDate, TaskComplexity complexity, TaskType type, TaskColors color, bool showNotification, NotificationType notificationType, String notificationMessage, bool closeScreen, bool isLoading, String? errorMessage
});




}
/// @nodoc
class __$TaskFormStateCopyWithImpl<$Res>
    implements _$TaskFormStateCopyWith<$Res> {
  __$TaskFormStateCopyWithImpl(this._self, this._then);

  final _TaskFormState _self;
  final $Res Function(_TaskFormState) _then;

/// Create a copy of TaskFormState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? taskId = freezed,Object? title = null,Object? titleError = freezed,Object? description = null,Object? descriptionError = freezed,Object? status = null,Object? priority = null,Object? dueDate = freezed,Object? complexity = null,Object? type = null,Object? color = null,Object? showNotification = null,Object? notificationType = null,Object? notificationMessage = null,Object? closeScreen = null,Object? isLoading = null,Object? errorMessage = freezed,}) {
  return _then(_TaskFormState(
taskId: freezed == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as int?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,titleError: freezed == titleError ? _self.titleError : titleError // ignore: cast_nullable_to_non_nullable
as String?,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,descriptionError: freezed == descriptionError ? _self.descriptionError : descriptionError // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TaskStatus,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as TaskPriority,dueDate: freezed == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,complexity: null == complexity ? _self.complexity : complexity // ignore: cast_nullable_to_non_nullable
as TaskComplexity,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TaskType,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as TaskColors,showNotification: null == showNotification ? _self.showNotification : showNotification // ignore: cast_nullable_to_non_nullable
as bool,notificationType: null == notificationType ? _self.notificationType : notificationType // ignore: cast_nullable_to_non_nullable
as NotificationType,notificationMessage: null == notificationMessage ? _self.notificationMessage : notificationMessage // ignore: cast_nullable_to_non_nullable
as String,closeScreen: null == closeScreen ? _self.closeScreen : closeScreen // ignore: cast_nullable_to_non_nullable
as bool,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
