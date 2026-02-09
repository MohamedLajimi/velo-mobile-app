import 'dart:io';
import 'package:fpdart/fpdart.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:karaba/core/error/failure.dart';
import 'package:karaba/core/services/permission_service.dart';

abstract class MediaService {
  Future<Either<Failure, File>> pickSingleImage({ImageSource source = ImageSource.gallery});
  Future<Either<Failure, List<File>>> pickMultipleImages();
  Future<Either<Failure, File>> pickSingleDocument();
  Future<Either<Failure, List<File>>> pickMultipleDocuments();
}

class MediaServiceImpl implements MediaService {
  final PermissionService _permissionService;
  final ImagePicker _imagePicker;
  final FilePicker _filePicker;

  MediaServiceImpl({
    required PermissionService permissionService,
    ImagePicker? imagePicker,
    FilePicker? filePicker,
  })  : _permissionService = permissionService,
        _imagePicker = imagePicker ?? ImagePicker(),
        _filePicker = filePicker ?? FilePicker.platform;

  @override
  Future<Either<Failure, File>> pickSingleImage({
    ImageSource source = ImageSource.gallery,
  }) async {
    try {
      final permissionResult = source == ImageSource.camera
          ? await _permissionService.requestCameraPermission()
          : await _permissionService.requestPhotosPermission();

      return permissionResult.fold(
        (failure) => left(failure),
        (_) async {
          final XFile? image = await _imagePicker.pickImage(
            source: source,
            imageQuality: 85,
          );

          if (image == null) {
            return left(const MediaFailure('media.no_image_selected'));
          }

          return right(File(image.path));
        },
      );
    } catch (e) {
      return left(MediaFailure('media.error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<File>>> pickMultipleImages() async {
    try {
      final permissionResult = await _permissionService.requestPhotosPermission();

      return permissionResult.fold(
        (failure) => left(failure),
        (_) async {
          final List<XFile> images = await _imagePicker.pickMultiImage(
            imageQuality: 85,
          );

          if (images.isEmpty) {
            return left(const MediaFailure('media.no_images_selected'));
          }

          final List<File> files = images.map((img) => File(img.path)).toList();
          return right(files);
        },
      );
    } catch (e) {
      return left(MediaFailure('media.error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, File>> pickSingleDocument() async {
    try {
      final permissionResult = await _permissionService.requestStoragePermission();

      return permissionResult.fold(
        (failure) => left(failure),
        (_) async {
          final FilePickerResult? result = await _filePicker.pickFiles(
            type: FileType.custom,
            allowedExtensions: ['pdf', 'doc', 'docx', 'txt'],
          );

          if (result == null || result.files.isEmpty) {
            return left(const MediaFailure('media.no_document_selected'));
          }

          final String? path = result.files.single.path;
          if (path == null) {
            return left(const MediaFailure('media.invalid_document'));
          }

          return right(File(path));
        },
      );
    } catch (e) {
      return left(MediaFailure('media.error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<File>>> pickMultipleDocuments() async {
    try {
      final permissionResult = await _permissionService.requestStoragePermission();

      return permissionResult.fold(
        (failure) => left(failure),
        (_) async {
          final FilePickerResult? result = await _filePicker.pickFiles(
            type: FileType.custom,
            allowedExtensions: ['pdf', 'doc', 'docx', 'txt'],
            allowMultiple: true,
          );

          if (result == null || result.files.isEmpty) {
            return left(const MediaFailure('media.no_documents_selected'));
          }

          final List<File> files = result.files
              .where((file) => file.path != null)
              .map((file) => File(file.path!))
              .toList();

          if (files.isEmpty) {
            return left(const MediaFailure('media.invalid_documents'));
          }

          return right(files);
        },
      );
    } catch (e) {
      return left(MediaFailure('media.error: ${e.toString()}'));
    }
  }
}