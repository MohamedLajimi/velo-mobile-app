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

  Future<void> deleteFiles({
    required String bucket,
    required List<String> paths,
  }) async {
    if (paths.isEmpty) return;
    await _supabaseClient.storage.from(bucket).remove(paths);
  }

  Future<void> deleteFilesByUrls({
    required String bucket,
    required List<String> urls,
  }) async {
    if (urls.isEmpty) return;

    final paths = urls.map((url) {
      final uri = Uri.parse(url);
      return uri.pathSegments.skip(2).join('/');
    }).toList();

    await deleteFiles(bucket: bucket, paths: paths);
  }

  Future<void> deleteFolder({
    required String bucket,
    required String folderPath,
  }) async {
    try {
      final files = await _supabaseClient.storage
          .from(bucket)
          .list(path: folderPath);

      if (files.isEmpty) return;

      final paths = files.map((file) => '$folderPath/${file.name}').toList();

      await _supabaseClient.storage.from(bucket).remove(paths);
    } catch (e) {
      return;
    }
  }

  Future<void> deleteFolders({
    required String bucket,
    required List<String> folderPaths,
  }) async {
    final tasks = folderPaths.map(
      (path) => deleteFolder(bucket: bucket, folderPath: path),
    );

    await Future.wait(tasks);
  }

  Future<void> deleteAllUnderPath({
    required String bucket,
    required String parentPath,
  }) async {
    try {
      final items = await _supabaseClient.storage
          .from(bucket)
          .list(path: parentPath);

      if (items.isEmpty) return;

      final deleteTasks = items.map((item) async {
        final itemPath = '$parentPath/${item.name}';

        if (item.metadata?['mimetype'] == null) {
          await deleteFolder(bucket: bucket, folderPath: itemPath);
        } else {
          await _supabaseClient.storage.from(bucket).remove([itemPath]);
        }
      });

      await Future.wait(deleteTasks);
    } catch (e) {
      return;
    }
  }
}
