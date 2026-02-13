import 'package:karaba/core/common/entities/document_entity.dart';
import 'package:karaba/core/common/enums/document_type.dart';

class DocumentModel extends DocumentEntity {
  const DocumentModel({
    required super.id,
    required super.ownerId,
    required super.relatedId,
    required super.type,
    required super.fileUrl,
    required super.createdAt,
  });

  factory DocumentModel.fromJson(Map<String, dynamic> json) {
    return DocumentModel(
      id: json['id'] as String,
      ownerId: json['ownerId'] as String,
      relatedId: json['relatedId'] as String,
      type: DocumentType.fromMap(json['type'] as String?),
      fileUrl: json['fileUrl'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
