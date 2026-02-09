import 'package:fpdart/fpdart.dart';
import 'package:karaba/core/error/failure.dart';
import 'package:permission_handler/permission_handler.dart';

abstract class PermissionService {
  Future<Either<PermissionFailure, bool>> requestCameraPermission();
  Future<Either<PermissionFailure, bool>> requestStoragePermission();
  Future<Either<PermissionFailure, bool>> requestPhotosPermission();
}

class PermissionServiceImpl implements PermissionService {
  @override
  Future<Either<PermissionFailure, bool>> requestCameraPermission() async {
    try {
      final status = await Permission.camera.request();

      if (status.isGranted) {
        return right(true);
      } else if (status.isPermanentlyDenied) {
        await openAppSettings();
        return left(const PermissionFailure('permissions.camera_denied'));
      } else {
        return left(const PermissionFailure('permissions.camera_required'));
      }
    } catch (e) {
      return left(PermissionFailure('permissions.error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<PermissionFailure, bool>> requestStoragePermission() async {
    try {
      final status = await Permission.storage.request();

      if (status.isGranted) {
        return right(true);
      } else if (status.isPermanentlyDenied) {
        await openAppSettings();
        return left(const PermissionFailure('permissions.storage_denied'));
      } else {
        return left(const PermissionFailure('permissions.storage_required'));
      }
    } catch (e) {
      return left(PermissionFailure('permissions.error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<PermissionFailure, bool>> requestPhotosPermission() async {
    try {
      final status = await Permission.photos.request();

      if (status.isGranted || status.isLimited) {
        return right(true);
      } else if (status.isPermanentlyDenied) {
        await openAppSettings();
        return left(const PermissionFailure('permissions.photos_denied'));
      } else {
        return left(const PermissionFailure('permissions.photos_required'));
      }
    } catch (e) {
      return left(PermissionFailure('permissions.error: ${e.toString()}'));
    }
  }
}
