import 'package:equatable/equatable.dart';
import 'package:karaba/core/common/enums/document_type.dart';

class DocumentEntity extends Equatable {
  final String id;
  final String ownerId;
  final String relatedId;
  final DocumentType type;
  final String fileUrl;
  final DateTime createdAt;

  const DocumentEntity({
    required this.id,
    required this.ownerId,
    required this.relatedId,
    required this.type,
    required this.fileUrl,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, ownerId, relatedId, type, fileUrl];
}