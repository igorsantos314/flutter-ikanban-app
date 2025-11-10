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

 TaskModel? get selectedTask; String get searchQuery; List<TaskModel> get tasks; bool get isLoading; bool get isLoadingMore; bool get hasMorePages; int get currentPage; bool get hasError; String get errorMessage; bool get showNotification; String get notificationMessage; NotificationType get notificationType; TaskStatus get statusFilter; bool get showFilterOptions; List<TaskType> get typeFilters; bool get showSortOptions; SortField get sortBy; SortOrder get sortOrder; bool get showStatusSelector; TaskLayout get layoutMode;
/// Create a copy of TaskListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskListStateCopyWith<TaskListState> get copyWith => _$TaskListStateCopyWithImpl<TaskListState>(this as TaskListState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskListState&&(identical(other.selectedTask, selectedTask) || other.selectedTask == selectedTask)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&const DeepCollectionEquality().equals(other.tasks, tasks)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.hasMorePages, hasMorePages) || other.hasMorePages == hasMorePages)&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.hasError, hasError) || other.hasError == hasError)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.showNotification, showNotification) || other.showNotification == showNotification)&&(identical(other.notificationMessage, notificationMessage) || other.notificationMessage == notificationMessage)&&(identical(other.notificationType, notificationType) || other.notificationType == notificationType)&&(identical(other.statusFilter, statusFilter) || other.statusFilter == statusFilter)&&(identical(other.showFilterOptions, showFilterOptions) || other.showFilterOptions == showFilterOptions)&&const DeepCollectionEquality().equals(other.typeFilters, typeFilters)&&(identical(other.showSortOptions, showSortOptions) || other.showSortOptions == showSortOptions)&&(identical(other.sortBy, sortBy) || other.sortBy == sortBy)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.showStatusSelector, showStatusSelector) || other.showStatusSelector == showStatusSelector)&&(identical(other.layoutMode, layoutMode) || other.layoutMode == layoutMode));
}


@override
int get hashCode => Object.hashAll([runtimeType,selectedTask,searchQuery,const DeepCollectionEquality().hash(tasks),isLoading,isLoadingMore,hasMorePages,currentPage,hasError,errorMessage,showNotification,notificationMessage,notificationType,statusFilter,showFilterOptions,const DeepCollectionEquality().hash(typeFilters),showSortOptions,sortBy,sortOrder,showStatusSelector,layoutMode]);

@override
String toString() {
  return 'TaskListState(selectedTask: $selectedTask, searchQuery: $searchQuery, tasks: $tasks, isLoading: $isLoading, isLoadingMore: $isLoadingMore, hasMorePages: $hasMorePages, currentPage: $currentPage, hasError: $hasError, errorMessage: $errorMessage, showNotification: $showNotification, notificationMessage: $notificationMessage, notificationType: $notificationType, statusFilter: $statusFilter, showFilterOptions: $showFilterOptions, typeFilters: $typeFilters, showSortOptions: $showSortOptions, sortBy: $sortBy, sortOrder: $sortOrder, showStatusSelector: $showStatusSelector, layoutMode: $layoutMode)';
}


}

/// @nodoc
abstract mixin class $TaskListStateCopyWith<$Res>  {
  factory $TaskListStateCopyWith(TaskListState value, $Res Function(TaskListState) _then) = _$TaskListStateCopyWithImpl;
@useResult
$Res call({
 TaskModel? selectedTask, String searchQuery, List<TaskModel> tasks, bool isLoading, bool isLoadingMore, bool hasMorePages, int currentPage, bool hasError, String errorMessage, bool showNotification, String notificationMessage, NotificationType notificationType, TaskStatus statusFilter, bool showFilterOptions, List<TaskType> typeFilters, bool showSortOptions, SortField sortBy, SortOrder sortOrder, bool showStatusSelector, TaskLayout layoutMode
});


$TaskModelCopyWith<$Res>? get selectedTask;

}
/// @nodoc
class _$TaskListStateCopyWithImpl<$Res>
    implements $TaskListStateCopyWith<$Res> {
  _$TaskListStateCopyWithImpl(this._self, this._then);

  final TaskListState _self;
  final $Res Function(TaskListState) _then;

/// Create a copy of TaskListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? selectedTask = freezed,Object? searchQuery = null,Object? tasks = null,Object? isLoading = null,Object? isLoadingMore = null,Object? hasMorePages = null,Object? currentPage = null,Object? hasError = null,Object? errorMessage = null,Object? showNotification = null,Object? notificationMessage = null,Object? notificationType = null,Object? statusFilter = null,Object? showFilterOptions = null,Object? typeFilters = null,Object? showSortOptions = null,Object? sortBy = null,Object? sortOrder = null,Object? showStatusSelector = null,Object? layoutMode = null,}) {
  return _then(_self.copyWith(
selectedTask: freezed == selectedTask ? _self.selectedTask : selectedTask // ignore: cast_nullable_to_non_nullable
as TaskModel?,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,tasks: null == tasks ? _self.tasks : tasks // ignore: cast_nullable_to_non_nullable
as List<TaskModel>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,hasMorePages: null == hasMorePages ? _self.hasMorePages : hasMorePages // ignore: cast_nullable_to_non_nullable
as bool,currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,hasError: null == hasError ? _self.hasError : hasError // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: null == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String,showNotification: null == showNotification ? _self.showNotification : showNotification // ignore: cast_nullable_to_non_nullable
as bool,notificationMessage: null == notificationMessage ? _self.notificationMessage : notificationMessage // ignore: cast_nullable_to_non_nullable
as String,notificationType: null == notificationType ? _self.notificationType : notificationType // ignore: cast_nullable_to_non_nullable
as NotificationType,statusFilter: null == statusFilter ? _self.statusFilter : statusFilter // ignore: cast_nullable_to_non_nullable
as TaskStatus,showFilterOptions: null == showFilterOptions ? _self.showFilterOptions : showFilterOptions // ignore: cast_nullable_to_non_nullable
as bool,typeFilters: null == typeFilters ? _self.typeFilters : typeFilters // ignore: cast_nullable_to_non_nullable
as List<TaskType>,showSortOptions: null == showSortOptions ? _self.showSortOptions : showSortOptions // ignore: cast_nullable_to_non_nullable
as bool,sortBy: null == sortBy ? _self.sortBy : sortBy // ignore: cast_nullable_to_non_nullable
as SortField,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as SortOrder,showStatusSelector: null == showStatusSelector ? _self.showStatusSelector : showStatusSelector // ignore: cast_nullable_to_non_nullable
as bool,layoutMode: null == layoutMode ? _self.layoutMode : layoutMode // ignore: cast_nullable_to_non_nullable
as TaskLayout,
  ));
}
/// Create a copy of TaskListState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TaskModelCopyWith<$Res>? get selectedTask {
    if (_self.selectedTask == null) {
    return null;
  }

  return $TaskModelCopyWith<$Res>(_self.selectedTask!, (value) {
    return _then(_self.copyWith(selectedTask: value));
  });
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TaskModel? selectedTask,  String searchQuery,  List<TaskModel> tasks,  bool isLoading,  bool isLoadingMore,  bool hasMorePages,  int currentPage,  bool hasError,  String errorMessage,  bool showNotification,  String notificationMessage,  NotificationType notificationType,  TaskStatus statusFilter,  bool showFilterOptions,  List<TaskType> typeFilters,  bool showSortOptions,  SortField sortBy,  SortOrder sortOrder,  bool showStatusSelector,  TaskLayout layoutMode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaskListState() when $default != null:
return $default(_that.selectedTask,_that.searchQuery,_that.tasks,_that.isLoading,_that.isLoadingMore,_that.hasMorePages,_that.currentPage,_that.hasError,_that.errorMessage,_that.showNotification,_that.notificationMessage,_that.notificationType,_that.statusFilter,_that.showFilterOptions,_that.typeFilters,_that.showSortOptions,_that.sortBy,_that.sortOrder,_that.showStatusSelector,_that.layoutMode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TaskModel? selectedTask,  String searchQuery,  List<TaskModel> tasks,  bool isLoading,  bool isLoadingMore,  bool hasMorePages,  int currentPage,  bool hasError,  String errorMessage,  bool showNotification,  String notificationMessage,  NotificationType notificationType,  TaskStatus statusFilter,  bool showFilterOptions,  List<TaskType> typeFilters,  bool showSortOptions,  SortField sortBy,  SortOrder sortOrder,  bool showStatusSelector,  TaskLayout layoutMode)  $default,) {final _that = this;
switch (_that) {
case _TaskListState():
return $default(_that.selectedTask,_that.searchQuery,_that.tasks,_that.isLoading,_that.isLoadingMore,_that.hasMorePages,_that.currentPage,_that.hasError,_that.errorMessage,_that.showNotification,_that.notificationMessage,_that.notificationType,_that.statusFilter,_that.showFilterOptions,_that.typeFilters,_that.showSortOptions,_that.sortBy,_that.sortOrder,_that.showStatusSelector,_that.layoutMode);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TaskModel? selectedTask,  String searchQuery,  List<TaskModel> tasks,  bool isLoading,  bool isLoadingMore,  bool hasMorePages,  int currentPage,  bool hasError,  String errorMessage,  bool showNotification,  String notificationMessage,  NotificationType notificationType,  TaskStatus statusFilter,  bool showFilterOptions,  List<TaskType> typeFilters,  bool showSortOptions,  SortField sortBy,  SortOrder sortOrder,  bool showStatusSelector,  TaskLayout layoutMode)?  $default,) {final _that = this;
switch (_that) {
case _TaskListState() when $default != null:
return $default(_that.selectedTask,_that.searchQuery,_that.tasks,_that.isLoading,_that.isLoadingMore,_that.hasMorePages,_that.currentPage,_that.hasError,_that.errorMessage,_that.showNotification,_that.notificationMessage,_that.notificationType,_that.statusFilter,_that.showFilterOptions,_that.typeFilters,_that.showSortOptions,_that.sortBy,_that.sortOrder,_that.showStatusSelector,_that.layoutMode);case _:
  return null;

}
}

}

/// @nodoc


class _TaskListState implements TaskListState {
  const _TaskListState({this.selectedTask, this.searchQuery = "", final  List<TaskModel> tasks = const [], this.isLoading = false, this.isLoadingMore = false, this.hasMorePages = true, this.currentPage = 1, this.hasError = false, this.errorMessage = "", this.showNotification = false, this.notificationMessage = "", this.notificationType = NotificationType.info, this.statusFilter = TaskStatus.todo, this.showFilterOptions = false, final  List<TaskType> typeFilters = const [], this.showSortOptions = false, this.sortBy = SortField.createdAt, this.sortOrder = SortOrder.ascending, this.showStatusSelector = false, this.layoutMode = TaskLayout.list}): _tasks = tasks,_typeFilters = typeFilters;
  

@override final  TaskModel? selectedTask;
@override@JsonKey() final  String searchQuery;
 final  List<TaskModel> _tasks;
@override@JsonKey() List<TaskModel> get tasks {
  if (_tasks is EqualUnmodifiableListView) return _tasks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tasks);
}

@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool isLoadingMore;
@override@JsonKey() final  bool hasMorePages;
@override@JsonKey() final  int currentPage;
@override@JsonKey() final  bool hasError;
@override@JsonKey() final  String errorMessage;
@override@JsonKey() final  bool showNotification;
@override@JsonKey() final  String notificationMessage;
@override@JsonKey() final  NotificationType notificationType;
@override@JsonKey() final  TaskStatus statusFilter;
@override@JsonKey() final  bool showFilterOptions;
 final  List<TaskType> _typeFilters;
@override@JsonKey() List<TaskType> get typeFilters {
  if (_typeFilters is EqualUnmodifiableListView) return _typeFilters;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_typeFilters);
}

@override@JsonKey() final  bool showSortOptions;
@override@JsonKey() final  SortField sortBy;
@override@JsonKey() final  SortOrder sortOrder;
@override@JsonKey() final  bool showStatusSelector;
@override@JsonKey() final  TaskLayout layoutMode;

/// Create a copy of TaskListState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskListStateCopyWith<_TaskListState> get copyWith => __$TaskListStateCopyWithImpl<_TaskListState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskListState&&(identical(other.selectedTask, selectedTask) || other.selectedTask == selectedTask)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&const DeepCollectionEquality().equals(other._tasks, _tasks)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.hasMorePages, hasMorePages) || other.hasMorePages == hasMorePages)&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.hasError, hasError) || other.hasError == hasError)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.showNotification, showNotification) || other.showNotification == showNotification)&&(identical(other.notificationMessage, notificationMessage) || other.notificationMessage == notificationMessage)&&(identical(other.notificationType, notificationType) || other.notificationType == notificationType)&&(identical(other.statusFilter, statusFilter) || other.statusFilter == statusFilter)&&(identical(other.showFilterOptions, showFilterOptions) || other.showFilterOptions == showFilterOptions)&&const DeepCollectionEquality().equals(other._typeFilters, _typeFilters)&&(identical(other.showSortOptions, showSortOptions) || other.showSortOptions == showSortOptions)&&(identical(other.sortBy, sortBy) || other.sortBy == sortBy)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.showStatusSelector, showStatusSelector) || other.showStatusSelector == showStatusSelector)&&(identical(other.layoutMode, layoutMode) || other.layoutMode == layoutMode));
}


@override
int get hashCode => Object.hashAll([runtimeType,selectedTask,searchQuery,const DeepCollectionEquality().hash(_tasks),isLoading,isLoadingMore,hasMorePages,currentPage,hasError,errorMessage,showNotification,notificationMessage,notificationType,statusFilter,showFilterOptions,const DeepCollectionEquality().hash(_typeFilters),showSortOptions,sortBy,sortOrder,showStatusSelector,layoutMode]);

@override
String toString() {
  return 'TaskListState(selectedTask: $selectedTask, searchQuery: $searchQuery, tasks: $tasks, isLoading: $isLoading, isLoadingMore: $isLoadingMore, hasMorePages: $hasMorePages, currentPage: $currentPage, hasError: $hasError, errorMessage: $errorMessage, showNotification: $showNotification, notificationMessage: $notificationMessage, notificationType: $notificationType, statusFilter: $statusFilter, showFilterOptions: $showFilterOptions, typeFilters: $typeFilters, showSortOptions: $showSortOptions, sortBy: $sortBy, sortOrder: $sortOrder, showStatusSelector: $showStatusSelector, layoutMode: $layoutMode)';
}


}

/// @nodoc
abstract mixin class _$TaskListStateCopyWith<$Res> implements $TaskListStateCopyWith<$Res> {
  factory _$TaskListStateCopyWith(_TaskListState value, $Res Function(_TaskListState) _then) = __$TaskListStateCopyWithImpl;
@override @useResult
$Res call({
 TaskModel? selectedTask, String searchQuery, List<TaskModel> tasks, bool isLoading, bool isLoadingMore, bool hasMorePages, int currentPage, bool hasError, String errorMessage, bool showNotification, String notificationMessage, NotificationType notificationType, TaskStatus statusFilter, bool showFilterOptions, List<TaskType> typeFilters, bool showSortOptions, SortField sortBy, SortOrder sortOrder, bool showStatusSelector, TaskLayout layoutMode
});


@override $TaskModelCopyWith<$Res>? get selectedTask;

}
/// @nodoc
class __$TaskListStateCopyWithImpl<$Res>
    implements _$TaskListStateCopyWith<$Res> {
  __$TaskListStateCopyWithImpl(this._self, this._then);

  final _TaskListState _self;
  final $Res Function(_TaskListState) _then;

/// Create a copy of TaskListState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? selectedTask = freezed,Object? searchQuery = null,Object? tasks = null,Object? isLoading = null,Object? isLoadingMore = null,Object? hasMorePages = null,Object? currentPage = null,Object? hasError = null,Object? errorMessage = null,Object? showNotification = null,Object? notificationMessage = null,Object? notificationType = null,Object? statusFilter = null,Object? showFilterOptions = null,Object? typeFilters = null,Object? showSortOptions = null,Object? sortBy = null,Object? sortOrder = null,Object? showStatusSelector = null,Object? layoutMode = null,}) {
  return _then(_TaskListState(
selectedTask: freezed == selectedTask ? _self.selectedTask : selectedTask // ignore: cast_nullable_to_non_nullable
as TaskModel?,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,tasks: null == tasks ? _self._tasks : tasks // ignore: cast_nullable_to_non_nullable
as List<TaskModel>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,hasMorePages: null == hasMorePages ? _self.hasMorePages : hasMorePages // ignore: cast_nullable_to_non_nullable
as bool,currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,hasError: null == hasError ? _self.hasError : hasError // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: null == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String,showNotification: null == showNotification ? _self.showNotification : showNotification // ignore: cast_nullable_to_non_nullable
as bool,notificationMessage: null == notificationMessage ? _self.notificationMessage : notificationMessage // ignore: cast_nullable_to_non_nullable
as String,notificationType: null == notificationType ? _self.notificationType : notificationType // ignore: cast_nullable_to_non_nullable
as NotificationType,statusFilter: null == statusFilter ? _self.statusFilter : statusFilter // ignore: cast_nullable_to_non_nullable
as TaskStatus,showFilterOptions: null == showFilterOptions ? _self.showFilterOptions : showFilterOptions // ignore: cast_nullable_to_non_nullable
as bool,typeFilters: null == typeFilters ? _self._typeFilters : typeFilters // ignore: cast_nullable_to_non_nullable
as List<TaskType>,showSortOptions: null == showSortOptions ? _self.showSortOptions : showSortOptions // ignore: cast_nullable_to_non_nullable
as bool,sortBy: null == sortBy ? _self.sortBy : sortBy // ignore: cast_nullable_to_non_nullable
as SortField,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as SortOrder,showStatusSelector: null == showStatusSelector ? _self.showStatusSelector : showStatusSelector // ignore: cast_nullable_to_non_nullable
as bool,layoutMode: null == layoutMode ? _self.layoutMode : layoutMode // ignore: cast_nullable_to_non_nullable
as TaskLayout,
  ));
}

/// Create a copy of TaskListState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TaskModelCopyWith<$Res>? get selectedTask {
    if (_self.selectedTask == null) {
    return null;
  }

  return $TaskModelCopyWith<$Res>(_self.selectedTask!, (value) {
    return _then(_self.copyWith(selectedTask: value));
  });
}
}

// dart format on
