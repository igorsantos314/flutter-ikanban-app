// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'checklist_item_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ChecklistItemModel {

 int? get id; String get title; String? get description; bool get isCompleted; int get taskId; DateTime get createdAt;
/// Create a copy of ChecklistItemModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChecklistItemModelCopyWith<ChecklistItemModel> get copyWith => _$ChecklistItemModelCopyWithImpl<ChecklistItemModel>(this as ChecklistItemModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChecklistItemModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted)&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,description,isCompleted,taskId,createdAt);

@override
String toString() {
  return 'ChecklistItemModel(id: $id, title: $title, description: $description, isCompleted: $isCompleted, taskId: $taskId, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $ChecklistItemModelCopyWith<$Res>  {
  factory $ChecklistItemModelCopyWith(ChecklistItemModel value, $Res Function(ChecklistItemModel) _then) = _$ChecklistItemModelCopyWithImpl;
@useResult
$Res call({
 int? id, String title, String? description, bool isCompleted, int taskId, DateTime createdAt
});




}
/// @nodoc
class _$ChecklistItemModelCopyWithImpl<$Res>
    implements $ChecklistItemModelCopyWith<$Res> {
  _$ChecklistItemModelCopyWithImpl(this._self, this._then);

  final ChecklistItemModel _self;
  final $Res Function(ChecklistItemModel) _then;

/// Create a copy of ChecklistItemModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? title = null,Object? description = freezed,Object? isCompleted = null,Object? taskId = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,taskId: null == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [ChecklistItemModel].
extension ChecklistItemModelPatterns on ChecklistItemModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChecklistItemModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChecklistItemModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChecklistItemModel value)  $default,){
final _that = this;
switch (_that) {
case _ChecklistItemModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChecklistItemModel value)?  $default,){
final _that = this;
switch (_that) {
case _ChecklistItemModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  String title,  String? description,  bool isCompleted,  int taskId,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChecklistItemModel() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.isCompleted,_that.taskId,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  String title,  String? description,  bool isCompleted,  int taskId,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _ChecklistItemModel():
return $default(_that.id,_that.title,_that.description,_that.isCompleted,_that.taskId,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  String title,  String? description,  bool isCompleted,  int taskId,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _ChecklistItemModel() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.isCompleted,_that.taskId,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc


class _ChecklistItemModel implements ChecklistItemModel {
  const _ChecklistItemModel({this.id, required this.title, this.description, this.isCompleted = false, required this.taskId, required this.createdAt});
  

@override final  int? id;
@override final  String title;
@override final  String? description;
@override@JsonKey() final  bool isCompleted;
@override final  int taskId;
@override final  DateTime createdAt;

/// Create a copy of ChecklistItemModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChecklistItemModelCopyWith<_ChecklistItemModel> get copyWith => __$ChecklistItemModelCopyWithImpl<_ChecklistItemModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChecklistItemModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted)&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,description,isCompleted,taskId,createdAt);

@override
String toString() {
  return 'ChecklistItemModel(id: $id, title: $title, description: $description, isCompleted: $isCompleted, taskId: $taskId, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$ChecklistItemModelCopyWith<$Res> implements $ChecklistItemModelCopyWith<$Res> {
  factory _$ChecklistItemModelCopyWith(_ChecklistItemModel value, $Res Function(_ChecklistItemModel) _then) = __$ChecklistItemModelCopyWithImpl;
@override @useResult
$Res call({
 int? id, String title, String? description, bool isCompleted, int taskId, DateTime createdAt
});




}
/// @nodoc
class __$ChecklistItemModelCopyWithImpl<$Res>
    implements _$ChecklistItemModelCopyWith<$Res> {
  __$ChecklistItemModelCopyWithImpl(this._self, this._then);

  final _ChecklistItemModel _self;
  final $Res Function(_ChecklistItemModel) _then;

/// Create a copy of ChecklistItemModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? title = null,Object? description = freezed,Object? isCompleted = null,Object? taskId = null,Object? createdAt = null,}) {
  return _then(_ChecklistItemModel(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,taskId: null == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
