import 'package:easy_localization/easy_localization.dart';

enum DocumentType {
  registration,
  insurance,
  technicalInspection,
  identityCard,
  paymentProof;

  static DocumentType fromMap(String? name) {
    if (name == null) return DocumentType.registration;

    final cleanName = name.trim().toLowerCase();

    return DocumentType.values.firstWhere(
      (e) => e.name == cleanName,
      orElse: () => DocumentType.registration,
    );
  }

  String get displayName => 'document_type.$name'.tr();
}
