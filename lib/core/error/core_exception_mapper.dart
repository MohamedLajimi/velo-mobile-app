import 'package:karaba/core/error/failure.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CoreExceptionMapper {
  static Failure map(dynamic e) {
    if (e is PostgrestException) {
      return DatabaseFailure('error.database_common');
    }

    if (e is StorageException) {
      return const UploadFailure('error.upload_failed');
    }

    if (e.toString().contains('SocketException')) {
      return const NetworkFailure();
    }

    return const ServerFailure();
  }
}
