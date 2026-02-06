// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signup_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SignupRequestModelImpl _$$SignupRequestModelImplFromJson(
  Map<String, dynamic> json,
) => _$SignupRequestModelImpl(
  email: json['email'] as String,
  phone: json['phone'] as String?,
  name: json['name'] as String,
  accessToken: json['access_token'] as String,
);

Map<String, dynamic> _$$SignupRequestModelImplToJson(
  _$SignupRequestModelImpl instance,
) => <String, dynamic>{
  'email': instance.email,
  'phone': instance.phone,
  'name': instance.name,
  'access_token': instance.accessToken,
};
