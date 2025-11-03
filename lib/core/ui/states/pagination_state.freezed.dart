// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pagination_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PaginationState {

 int get itemsPerPage; int get currentPage; int get pageSize; int get totalItems; int get totalPages;
/// Create a copy of PaginationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaginationStateCopyWith<PaginationState> get copyWith => _$PaginationStateCopyWithImpl<PaginationState>(this as PaginationState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaginationState&&(identical(other.itemsPerPage, itemsPerPage) || other.itemsPerPage == itemsPerPage)&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.pageSize, pageSize) || other.pageSize == pageSize)&&(identical(other.totalItems, totalItems) || other.totalItems == totalItems)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages));
}


@override
int get hashCode => Object.hash(runtimeType,itemsPerPage,currentPage,pageSize,totalItems,totalPages);

@override
String toString() {
  return 'PaginationState(itemsPerPage: $itemsPerPage, currentPage: $currentPage, pageSize: $pageSize, totalItems: $totalItems, totalPages: $totalPages)';
}


}

/// @nodoc
abstract mixin class $PaginationStateCopyWith<$Res>  {
  factory $PaginationStateCopyWith(PaginationState value, $Res Function(PaginationState) _then) = _$PaginationStateCopyWithImpl;
@useResult
$Res call({
 int itemsPerPage, int currentPage, int pageSize, int totalItems, int totalPages
});




}
/// @nodoc
class _$PaginationStateCopyWithImpl<$Res>
    implements $PaginationStateCopyWith<$Res> {
  _$PaginationStateCopyWithImpl(this._self, this._then);

  final PaginationState _self;
  final $Res Function(PaginationState) _then;

/// Create a copy of PaginationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? itemsPerPage = null,Object? currentPage = null,Object? pageSize = null,Object? totalItems = null,Object? totalPages = null,}) {
  return _then(_self.copyWith(
itemsPerPage: null == itemsPerPage ? _self.itemsPerPage : itemsPerPage // ignore: cast_nullable_to_non_nullable
as int,currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,pageSize: null == pageSize ? _self.pageSize : pageSize // ignore: cast_nullable_to_non_nullable
as int,totalItems: null == totalItems ? _self.totalItems : totalItems // ignore: cast_nullable_to_non_nullable
as int,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PaginationState].
extension PaginationStatePatterns on PaginationState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaginationState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaginationState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaginationState value)  $default,){
final _that = this;
switch (_that) {
case _PaginationState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaginationState value)?  $default,){
final _that = this;
switch (_that) {
case _PaginationState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int itemsPerPage,  int currentPage,  int pageSize,  int totalItems,  int totalPages)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaginationState() when $default != null:
return $default(_that.itemsPerPage,_that.currentPage,_that.pageSize,_that.totalItems,_that.totalPages);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int itemsPerPage,  int currentPage,  int pageSize,  int totalItems,  int totalPages)  $default,) {final _that = this;
switch (_that) {
case _PaginationState():
return $default(_that.itemsPerPage,_that.currentPage,_that.pageSize,_that.totalItems,_that.totalPages);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int itemsPerPage,  int currentPage,  int pageSize,  int totalItems,  int totalPages)?  $default,) {final _that = this;
switch (_that) {
case _PaginationState() when $default != null:
return $default(_that.itemsPerPage,_that.currentPage,_that.pageSize,_that.totalItems,_that.totalPages);case _:
  return null;

}
}

}

/// @nodoc


class _PaginationState implements PaginationState {
  const _PaginationState({this.itemsPerPage = 10, this.currentPage = 1, this.pageSize = 0, this.totalItems = 0, this.totalPages = 0});
  

@override@JsonKey() final  int itemsPerPage;
@override@JsonKey() final  int currentPage;
@override@JsonKey() final  int pageSize;
@override@JsonKey() final  int totalItems;
@override@JsonKey() final  int totalPages;

/// Create a copy of PaginationState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaginationStateCopyWith<_PaginationState> get copyWith => __$PaginationStateCopyWithImpl<_PaginationState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaginationState&&(identical(other.itemsPerPage, itemsPerPage) || other.itemsPerPage == itemsPerPage)&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.pageSize, pageSize) || other.pageSize == pageSize)&&(identical(other.totalItems, totalItems) || other.totalItems == totalItems)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages));
}


@override
int get hashCode => Object.hash(runtimeType,itemsPerPage,currentPage,pageSize,totalItems,totalPages);

@override
String toString() {
  return 'PaginationState(itemsPerPage: $itemsPerPage, currentPage: $currentPage, pageSize: $pageSize, totalItems: $totalItems, totalPages: $totalPages)';
}


}

/// @nodoc
abstract mixin class _$PaginationStateCopyWith<$Res> implements $PaginationStateCopyWith<$Res> {
  factory _$PaginationStateCopyWith(_PaginationState value, $Res Function(_PaginationState) _then) = __$PaginationStateCopyWithImpl;
@override @useResult
$Res call({
 int itemsPerPage, int currentPage, int pageSize, int totalItems, int totalPages
});




}
/// @nodoc
class __$PaginationStateCopyWithImpl<$Res>
    implements _$PaginationStateCopyWith<$Res> {
  __$PaginationStateCopyWithImpl(this._self, this._then);

  final _PaginationState _self;
  final $Res Function(_PaginationState) _then;

/// Create a copy of PaginationState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? itemsPerPage = null,Object? currentPage = null,Object? pageSize = null,Object? totalItems = null,Object? totalPages = null,}) {
  return _then(_PaginationState(
itemsPerPage: null == itemsPerPage ? _self.itemsPerPage : itemsPerPage // ignore: cast_nullable_to_non_nullable
as int,currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,pageSize: null == pageSize ? _self.pageSize : pageSize // ignore: cast_nullable_to_non_nullable
as int,totalItems: null == totalItems ? _self.totalItems : totalItems // ignore: cast_nullable_to_non_nullable
as int,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
