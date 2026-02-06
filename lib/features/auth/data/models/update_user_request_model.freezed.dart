// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_user_request_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

UpdateUserRequestModel _$UpdateUserRequestModelFromJson(
  Map<String, dynamic> json,
) {
  return _UpdateUserRequestModel.fromJson(json);
}

/// @nodoc
mixin _$UpdateUserRequestModel {
  String? get name => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;

  /// Serializes this UpdateUserRequestModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UpdateUserRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpdateUserRequestModelCopyWith<UpdateUserRequestModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateUserRequestModelCopyWith<$Res> {
  factory $UpdateUserRequestModelCopyWith(
    UpdateUserRequestModel value,
    $Res Function(UpdateUserRequestModel) then,
  ) = _$UpdateUserRequestModelCopyWithImpl<$Res, UpdateUserRequestModel>;
  @useResult
  $Res call({String? name, String? phone});
}

/// @nodoc
class _$UpdateUserRequestModelCopyWithImpl<
  $Res,
  $Val extends UpdateUserRequestModel
>
    implements $UpdateUserRequestModelCopyWith<$Res> {
  _$UpdateUserRequestModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdateUserRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? name = freezed, Object? phone = freezed}) {
    return _then(
      _value.copyWith(
            name: freezed == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String?,
            phone: freezed == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UpdateUserRequestModelImplCopyWith<$Res>
    implements $UpdateUserRequestModelCopyWith<$Res> {
  factory _$$UpdateUserRequestModelImplCopyWith(
    _$UpdateUserRequestModelImpl value,
    $Res Function(_$UpdateUserRequestModelImpl) then,
  ) = __$$UpdateUserRequestModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? name, String? phone});
}

/// @nodoc
class __$$UpdateUserRequestModelImplCopyWithImpl<$Res>
    extends
        _$UpdateUserRequestModelCopyWithImpl<$Res, _$UpdateUserRequestModelImpl>
    implements _$$UpdateUserRequestModelImplCopyWith<$Res> {
  __$$UpdateUserRequestModelImplCopyWithImpl(
    _$UpdateUserRequestModelImpl _value,
    $Res Function(_$UpdateUserRequestModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UpdateUserRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? name = freezed, Object? phone = freezed}) {
    return _then(
      _$UpdateUserRequestModelImpl(
        name: freezed == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String?,
        phone: freezed == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UpdateUserRequestModelImpl implements _UpdateUserRequestModel {
  const _$UpdateUserRequestModelImpl({this.name, this.phone});

  factory _$UpdateUserRequestModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UpdateUserRequestModelImplFromJson(json);

  @override
  final String? name;
  @override
  final String? phone;

  @override
  String toString() {
    return 'UpdateUserRequestModel(name: $name, phone: $phone)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateUserRequestModelImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.phone, phone) || other.phone == phone));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, phone);

  /// Create a copy of UpdateUserRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateUserRequestModelImplCopyWith<_$UpdateUserRequestModelImpl>
  get copyWith =>
      __$$UpdateUserRequestModelImplCopyWithImpl<_$UpdateUserRequestModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$UpdateUserRequestModelImplToJson(this);
  }
}

abstract class _UpdateUserRequestModel implements UpdateUserRequestModel {
  const factory _UpdateUserRequestModel({
    final String? name,
    final String? phone,
  }) = _$UpdateUserRequestModelImpl;

  factory _UpdateUserRequestModel.fromJson(Map<String, dynamic> json) =
      _$UpdateUserRequestModelImpl.fromJson;

  @override
  String? get name;
  @override
  String? get phone;

  /// Create a copy of UpdateUserRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateUserRequestModelImplCopyWith<_$UpdateUserRequestModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
