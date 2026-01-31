import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class StorageService {
  final SupabaseClient _supabaseClient;
  const StorageService({required SupabaseClient supabaseClient})
    : _supabaseClient = supabaseClient;

  Future<String?> uploadFile({
    required String bucket,
    required String folderPath,
    required String localPath,
    required String prefix,
  }) async {
    try {
      final file = File(localPath);

      final String fileExtension = localPath.split('.').last;

      final String fileName =
          '${prefix}_${DateTime.now().millisecondsSinceEpoch}.$fileExtension';

      final String remotePath = '$folderPath/$fileName';

      await _supabaseClient.storage
          .from(bucket)
          .upload(
            remotePath,
            file,
            fileOptions: const FileOptions(upsert: true),
          );

      return _supabaseClient.storage.from(bucket).getPublicUrl(remotePath);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<String>> uploadMultipleFiles({
    required String bucket,
    required String folderPath,
    required List<String> localPaths,
    required String prefix,
  }) async {
    final uploadTasks = localPaths.map((path) {
      return uploadFile(
        bucket: bucket,
        folderPath: folderPath,
        localPath: path,
        prefix: prefix,
      );
    });

    final List<String?> results = await Future.wait(uploadTasks);

    return results.whereType<String>().toList();
  }
}
