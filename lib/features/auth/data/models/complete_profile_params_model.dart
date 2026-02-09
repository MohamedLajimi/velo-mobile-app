import 'package:karaba/features/auth/domain/usecases/complete_profile_use_case.dart';

class CompleteProfileParamsModel extends CompleteProfileParams {
  const CompleteProfileParamsModel({
    required super.userId,
    required super.phoneNumber,
    required super.role,
    required super.idCardPath,
  });

  Map<String, dynamic> toJson() {
    return {'phone_number': phoneNumber, 'role': role.name};
  }

  factory CompleteProfileParamsModel.fromEntity(CompleteProfileParams params) =>
      CompleteProfileParamsModel(
        userId: params.userId,
        phoneNumber: params.phoneNumber,
        role: params.role,
        idCardPath: params.idCardPath,
      );
}
