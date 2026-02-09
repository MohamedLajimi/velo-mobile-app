import 'package:karaba/features/auth/domain/usecases/sign_up_with_email_use_case.dart';

class SignUpParamsModel extends SignUpParams {
  const SignUpParamsModel({
    required super.fullName,
    required super.email,
    required super.password,
    required super.phoneNumber,
    required super.role,
    super.avatarUrl,
    required super.idCardUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'full_name': fullName,
      'email': email,
      'phone_number': phoneNumber,
      'role': role.name,
    };
  }

  factory SignUpParamsModel.fromEntity(SignUpParams params) =>
      SignUpParamsModel(
        fullName: params.fullName,
        email: params.email,
        password: params.password,
        phoneNumber: params.phoneNumber,
        role: params.role,
        idCardUrl: params.idCardUrl,
      );
}
