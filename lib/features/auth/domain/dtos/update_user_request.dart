import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_user_request.freezed.dart';

@freezed
class UpdateUserRequest with _$UpdateUserRequest {
  const factory UpdateUserRequest({String? name, String? phone}) =
      _UpdateUserRequest;
}
