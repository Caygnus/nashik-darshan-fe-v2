import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_user_request_model.freezed.dart';
part 'update_user_request_model.g.dart';

@freezed
class UpdateUserRequestModel with _$UpdateUserRequestModel {
  const factory UpdateUserRequestModel({String? name, String? phone}) =
      _UpdateUserRequestModel;

  factory UpdateUserRequestModel.fromJson(Map<String, dynamic> json) =>
      _$UpdateUserRequestModelFromJson(json);
}
