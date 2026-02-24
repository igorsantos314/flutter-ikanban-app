// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TaskModel {

 int? get id; String get title; String? get description; TaskStatus get status; TaskPriority get priority; DateTime? get dueDate; TaskComplexity get complexity; TaskType get type; TaskColors get color; bool get isActive; DateTime get createdAt; int? get boardId;
/// Create a copy of TaskModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskModelCopyWith<TaskModel> get copyWith => _$TaskModelCopyWithImpl<TaskModel>(this as TaskModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.status, status) || other.status == status)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.complexity, complexity) || other.complexity == complexity)&&(identical(other.type, type) || other.type == type)&&(identical(other.color, color) || other.color == color)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.boardId, boardId) || other.boardId == boardId));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,description,status,priority,dueDate,complexity,type,color,isActive,createdAt,boardId);

@override
String toString() {
  return 'TaskModel(id: $id, title: $title, description: $description, status: $status, priority: $priority, dueDate: $dueDate, complexity: $complexity, type: $type, color: $color, isActive: $isActive, createdAt: $createdAt, boardId: $boardId)';
}


}

/// @nodoc
abstract mixin class $TaskModelCopyWith<$Res>  {
  factory $TaskModelCopyWith(TaskModel value, $Res Function(TaskModel) _then) = _$TaskModelCopyWithImpl;
@useResult
$Res call({
 int? id, String title, String? description, TaskStatus status, TaskPriority priority, DateTime? dueDate, TaskComplexity complexity, TaskType type, TaskColors color, bool isActive, DateTime createdAt, int? boardId
});




}
/// @nodoc
class _$TaskModelCopyWithImpl<$Res>
    implements $TaskModelCopyWith<$Res> {
  _$TaskModelCopyWithImpl(this._self, this._then);

  final TaskModel _self;
  final $Res Function(TaskModel) _then;

/// Create a copy of TaskModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? title = null,Object? description = freezed,Object? status = null,Object? priority = null,Object? dueDate = freezed,Object? complexity = null,Object? type = null,Object? color = null,Object? isActive = null,Object? createdAt = null,Object? boardId = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TaskStatus,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as TaskPriority,dueDate: freezed == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,complexity: null == complexity ? _self.complexity : complexity // ignore: cast_nullable_to_non_nullable
as TaskComplexity,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TaskType,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as TaskColors,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,boardId: freezed == boardId ? _self.boardId : boardId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [TaskModel].
extension TaskModelPatterns on TaskModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaskModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaskModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaskModel value)  $default,){
final _that = this;
switch (_that) {
case _TaskModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaskModel value)?  $default,){
final _that = this;
switch (_that) {
case _TaskModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  String title,  String? description,  TaskStatus status,  TaskPriority priority,  DateTime? dueDate,  TaskComplexity complexity,  TaskType type,  TaskColors color,  bool isActive,  DateTime createdAt,  int? boardId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaskModel() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.status,_that.priority,_that.dueDate,_that.complexity,_that.type,_that.color,_that.isActive,_that.createdAt,_that.boardId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  String title,  String? description,  TaskStatus status,  TaskPriority priority,  DateTime? dueDate,  TaskComplexity complexity,  TaskType type,  TaskColors color,  bool isActive,  DateTime createdAt,  int? boardId)  $default,) {final _that = this;
switch (_that) {
case _TaskModel():
return $default(_that.id,_that.title,_that.description,_that.status,_that.priority,_that.dueDate,_that.complexity,_that.type,_that.color,_that.isActive,_that.createdAt,_that.boardId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  String title,  String? description,  TaskStatus status,  TaskPriority priority,  DateTime? dueDate,  TaskComplexity complexity,  TaskType type,  TaskColors color,  bool isActive,  DateTime createdAt,  int? boardId)?  $default,) {final _that = this;
switch (_that) {
case _TaskModel() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.status,_that.priority,_that.dueDate,_that.complexity,_that.type,_that.color,_that.isActive,_that.createdAt,_that.boardId);case _:
  return null;

}
}

}

/// @nodoc


class _TaskModel implements TaskModel {
  const _TaskModel({this.id, required this.title, this.description, this.status = TaskStatus.backlog, this.priority = TaskPriority.low, this.dueDate, this.complexity = TaskComplexity.easy, this.type = TaskType.personal, this.color = TaskColors.defaultColor, this.isActive = true, required this.createdAt, this.boardId});
  

@override final  int? id;
@override final  String title;
@override final  String? description;
@override@JsonKey() final  TaskStatus status;
@override@JsonKey() final  TaskPriority priority;
@override final  DateTime? dueDate;
@override@JsonKey() final  TaskComplexity complexity;
@override@JsonKey() final  TaskType type;
@override@JsonKey() final  TaskColors color;
@override@JsonKey() final  bool isActive;
@override final  DateTime createdAt;
@override final  int? boardId;

/// Create a copy of TaskModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskModelCopyWith<_TaskModel> get copyWith => __$TaskModelCopyWithImpl<_TaskModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.status, status) || other.status == status)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.complexity, complexity) || other.complexity == complexity)&&(identical(other.type, type) || other.type == type)&&(identical(other.color, color) || other.color == color)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.boardId, boardId) || other.boardId == boardId));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,description,status,priority,dueDate,complexity,type,color,isActive,createdAt,boardId);

@override
String toString() {
  return 'TaskModel(id: $id, title: $title, description: $description, status: $status, priority: $priority, dueDate: $dueDate, complexity: $complexity, type: $type, color: $color, isActive: $isActive, createdAt: $createdAt, boardId: $boardId)';
}


}

/// @nodoc
abstract mixin class _$TaskModelCopyWith<$Res> implements $TaskModelCopyWith<$Res> {
  factory _$TaskModelCopyWith(_TaskModel value, $Res Function(_TaskModel) _then) = __$TaskModelCopyWithImpl;
@override @useResult
$Res call({
 int? id, String title, String? description, TaskStatus status, TaskPriority priority, DateTime? dueDate, TaskComplexity complexity, TaskType type, TaskColors color, bool isActive, DateTime createdAt, int? boardId
});




}
/// @nodoc
class __$TaskModelCopyWithImpl<$Res>
    implements _$TaskModelCopyWith<$Res> {
  __$TaskModelCopyWithImpl(this._self, this._then);

  final _TaskModel _self;
  final $Res Function(_TaskModel) _then;

/// Create a copy of TaskModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? title = null,Object? description = freezed,Object? status = null,Object? priority = null,Object? dueDate = freezed,Object? complexity = null,Object? type = null,Object? color = null,Object? isActive = null,Object? createdAt = null,Object? boardId = freezed,}) {
  return _then(_TaskModel(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TaskStatus,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as TaskPriority,dueDate: freezed == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,complexity: null == complexity ? _self.complexity : complexity // ignore: cast_nullable_to_non_nullable
as TaskComplexity,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TaskType,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as TaskColors,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,boardId: freezed == boardId ? _self.boardId : boardId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
