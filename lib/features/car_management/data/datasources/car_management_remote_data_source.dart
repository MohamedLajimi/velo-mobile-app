import 'package:karaba/core/common/enums/document_type.dart';
import 'package:karaba/core/common/models/car_model.dart';
import 'package:karaba/core/common/models/document_model.dart';
import 'package:karaba/core/common/models/pagination_response.dart';
import 'package:karaba/core/services/storage_service.dart';
import 'package:karaba/features/car_management/data/models/car_form_model.dart';
import 'package:karaba/features/car_management/data/models/get_owner_cars_params_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class CarManagementRemoteDataSource {
  Future<PaginationResponse<CarModel>> getOwnerCars({
    required GetOwnerCarsParamsModel params,
  });

  Future<CarModel> getCarDetails({required String carId});

  Future<CarModel> addCar({required CarFormModel params});

  Future<CarModel> updateCar({required CarFormModel params});

  Future<void> deleteCar({required String carId});

  Future<List<DocumentModel>> getCarDocuments({required String carId});
}

class SupabaseCarManagmentRemoteDataSource
    implements CarManagementRemoteDataSource {
  final SupabaseClient _supabaseClient;
  final StorageService _storageService;

  const SupabaseCarManagmentRemoteDataSource({
    required SupabaseClient supabaseClient,
    required StorageService storageService,
  }) : _supabaseClient = supabaseClient,
       _storageService = storageService;

  @override
  Future<PaginationResponse<CarModel>> getOwnerCars({
    required GetOwnerCarsParamsModel params,
  }) async {
    var query = _supabaseClient
        .from('cars')
        .select('*, car_locations(*), owner:profiles(*)')
        .eq('owner_id', _currentUserId);

    final response = await params.applyFilters(query);

    final List<dynamic> data = response.data as List<dynamic>;
    final int count = response.count ?? 0;

    final cars = data.map((json) => CarModel.fromJson(json)).toList();

    return PaginationResponse(
      items: cars,
      totalCount: count,
      hasNextPage: count > (cars.length + params.skip),
    );
  }

  @override
  Future<CarModel> addCar({required CarFormModel params}) async {
    final carResponse = await _supabaseClient
        .from('cars')
        .insert({'ownerId': _currentUserId, ...params.toJson()})
        .select()
        .single();

    final String carId = carResponse['id'];

    final imageUrls = await _storageService.uploadMultipleFiles(
      bucket: 'car_media',
      folderPath: 'cars/$carId/images',
      localPaths: params.images,
      prefix: 'car_img',
    );

    await _uploadCarDocuments(carId: carId, documents: params.documents);

    await _supabaseClient.from('car_locations').insert({
      'car_id': carId,
      'address': params.location.address,
      'city': params.location.city,
      'latitude': params.location.lat,
      'longitude': params.location.lng,
    });

    await _supabaseClient
        .from('cars')
        .update({'images': imageUrls})
        .eq('id', carId);

    return getCarDetails(carId: carId);
  }

  @override
  Future<CarModel> updateCar({required CarFormModel params}) async {
    final carId = params.id!;

    final existing = await _supabaseClient
        .from('cars')
        .select('images')
        .eq('id', carId)
        .single();

    final existingImages =
        (existing['images'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [];

    final newLocalImages = <String>[];
    final keptImages = <String>[];

    for (final image in params.images) {
      image.startsWith('http')
          ? keptImages.add(image)
          : newLocalImages.add(image);
    }

    List<String> newImageUrls = [];

    if (newLocalImages.isNotEmpty) {
      newImageUrls = await _storageService.uploadMultipleFiles(
        bucket: 'car_media',
        folderPath: 'cars/$carId/images',
        localPaths: newLocalImages,
        prefix: 'car_img',
      );
    }

    final allImages = [...keptImages, ...newImageUrls];

    final removedImages = existingImages
        .where((url) => !keptImages.contains(url))
        .toList();

    if (removedImages.isNotEmpty) {
      await _storageService.deleteFilesByUrls(
        bucket: 'car_media',
        urls: removedImages,
      );
    }

    if (params.documents.isNotEmpty) {
      await _uploadCarDocuments(carId: carId, documents: params.documents);
    }

    await _supabaseClient
        .from('cars')
        .update({...params.toJson(), 'images': allImages})
        .eq('id', carId);

    await _supabaseClient
        .from('car_locations')
        .update({
          'address': params.location.address,
          'city': params.location.city,
          'latitude': params.location.lat,
          'longitude': params.location.lng,
        })
        .eq('car_id', carId);

    return getCarDetails(carId: carId);
  }

  @override
  Future<void> deleteCar({required String carId}) async {
    await _storageService.deleteAllUnderPath(
      bucket: 'car_media',
      parentPath: 'cars/$carId',
    );

    await _supabaseClient.from('cars').delete().eq('id', carId);
  }

  @override
  Future<CarModel> getCarDetails({required String carId}) async {
    final carResponse = await _supabaseClient
        .from('cars')
        .select('*, car_locations(*), owner:profiles(*)')
        .eq('id', carId)
        .single();

    return CarModel.fromJson(carResponse);
  }

  @override
  Future<List<DocumentModel>> getCarDocuments({required String carId}) async {
    final documentsResponse = await _supabaseClient
        .from('documents')
        .select()
        .eq('related_id', carId)
        .order('created_at', ascending: false);

    return documentsResponse.map((e) => DocumentModel.fromJson(e)).toList();
  }

  String get _currentUserId {
    final userId = _supabaseClient.auth.currentSession?.user.id;
    if (userId == null) throw AuthException('');
    return userId;
  }

  Future<void> _uploadCarDocuments({
    required String carId,
    required List<(String localPath, DocumentType type)> documents,
  }) async {
    if (documents.isEmpty) return;

    final tasks = documents.map((doc) async {
      final localPath = doc.$1;
      final docType = doc.$2;

      final url = await _storageService.uploadFile(
        bucket: 'car_media',
        folderPath: 'cars/$carId/documents',
        localPath: localPath,
        prefix: docType.name,
      );

      if (url != null) {
        await _supabaseClient.from('documents').insert({
          'owner_id': _currentUserId,
          'related_id': carId,
          'type': docType.name,
          'file_url': url,
        });
      }
    });

    await Future.wait(tasks);
  }
}
