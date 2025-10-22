// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'result_page.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ResultPage<T> {

 int get number; int get limitPerPage; int get totalItems; int get totalPages; List<T> get items;
/// Create a copy of ResultPage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ResultPageCopyWith<T, ResultPage<T>> get copyWith => _$ResultPageCopyWithImpl<T, ResultPage<T>>(this as ResultPage<T>, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResultPage<T>&&(identical(other.number, number) || other.number == number)&&(identical(other.limitPerPage, limitPerPage) || other.limitPerPage == limitPerPage)&&(identical(other.totalItems, totalItems) || other.totalItems == totalItems)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages)&&const DeepCollectionEquality().equals(other.items, items));
}


@override
int get hashCode => Object.hash(runtimeType,number,limitPerPage,totalItems,totalPages,const DeepCollectionEquality().hash(items));

@override
String toString() {
  return 'ResultPage<$T>(number: $number, limitPerPage: $limitPerPage, totalItems: $totalItems, totalPages: $totalPages, items: $items)';
}


}

/// @nodoc
abstract mixin class $ResultPageCopyWith<T,$Res>  {
  factory $ResultPageCopyWith(ResultPage<T> value, $Res Function(ResultPage<T>) _then) = _$ResultPageCopyWithImpl;
@useResult
$Res call({
 int number, int limitPerPage, int totalItems, int totalPages, List<T> items
});




}
/// @nodoc
class _$ResultPageCopyWithImpl<T,$Res>
    implements $ResultPageCopyWith<T, $Res> {
  _$ResultPageCopyWithImpl(this._self, this._then);

  final ResultPage<T> _self;
  final $Res Function(ResultPage<T>) _then;

/// Create a copy of ResultPage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? number = null,Object? limitPerPage = null,Object? totalItems = null,Object? totalPages = null,Object? items = null,}) {
  return _then(_self.copyWith(
number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,limitPerPage: null == limitPerPage ? _self.limitPerPage : limitPerPage // ignore: cast_nullable_to_non_nullable
as int,totalItems: null == totalItems ? _self.totalItems : totalItems // ignore: cast_nullable_to_non_nullable
as int,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<T>,
  ));
}

}


/// Adds pattern-matching-related methods to [ResultPage].
extension ResultPagePatterns<T> on ResultPage<T> {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ResultPage<T> value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ResultPage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ResultPage<T> value)  $default,){
final _that = this;
switch (_that) {
case _ResultPage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ResultPage<T> value)?  $default,){
final _that = this;
switch (_that) {
case _ResultPage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int number,  int limitPerPage,  int totalItems,  int totalPages,  List<T> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ResultPage() when $default != null:
return $default(_that.number,_that.limitPerPage,_that.totalItems,_that.totalPages,_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int number,  int limitPerPage,  int totalItems,  int totalPages,  List<T> items)  $default,) {final _that = this;
switch (_that) {
case _ResultPage():
return $default(_that.number,_that.limitPerPage,_that.totalItems,_that.totalPages,_that.items);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int number,  int limitPerPage,  int totalItems,  int totalPages,  List<T> items)?  $default,) {final _that = this;
switch (_that) {
case _ResultPage() when $default != null:
return $default(_that.number,_that.limitPerPage,_that.totalItems,_that.totalPages,_that.items);case _:
  return null;

}
}

}

/// @nodoc


class _ResultPage<T> implements ResultPage<T> {
  const _ResultPage({required this.number, required this.limitPerPage, required this.totalItems, required this.totalPages, required final  List<T> items}): _items = items;
  

@override final  int number;
@override final  int limitPerPage;
@override final  int totalItems;
@override final  int totalPages;
 final  List<T> _items;
@override List<T> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of ResultPage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ResultPageCopyWith<T, _ResultPage<T>> get copyWith => __$ResultPageCopyWithImpl<T, _ResultPage<T>>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ResultPage<T>&&(identical(other.number, number) || other.number == number)&&(identical(other.limitPerPage, limitPerPage) || other.limitPerPage == limitPerPage)&&(identical(other.totalItems, totalItems) || other.totalItems == totalItems)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages)&&const DeepCollectionEquality().equals(other._items, _items));
}


@override
int get hashCode => Object.hash(runtimeType,number,limitPerPage,totalItems,totalPages,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'ResultPage<$T>(number: $number, limitPerPage: $limitPerPage, totalItems: $totalItems, totalPages: $totalPages, items: $items)';
}


}

/// @nodoc
abstract mixin class _$ResultPageCopyWith<T,$Res> implements $ResultPageCopyWith<T, $Res> {
  factory _$ResultPageCopyWith(_ResultPage<T> value, $Res Function(_ResultPage<T>) _then) = __$ResultPageCopyWithImpl;
@override @useResult
$Res call({
 int number, int limitPerPage, int totalItems, int totalPages, List<T> items
});




}
/// @nodoc
class __$ResultPageCopyWithImpl<T,$Res>
    implements _$ResultPageCopyWith<T, $Res> {
  __$ResultPageCopyWithImpl(this._self, this._then);

  final _ResultPage<T> _self;
  final $Res Function(_ResultPage<T>) _then;

/// Create a copy of ResultPage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? number = null,Object? limitPerPage = null,Object? totalItems = null,Object? totalPages = null,Object? items = null,}) {
  return _then(_ResultPage<T>(
number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,limitPerPage: null == limitPerPage ? _self.limitPerPage : limitPerPage // ignore: cast_nullable_to_non_nullable
as int,totalItems: null == totalItems ? _self.totalItems : totalItems // ignore: cast_nullable_to_non_nullable
as int,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<T>,
  ));
}


}

// dart format on
