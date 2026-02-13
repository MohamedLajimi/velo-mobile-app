import 'package:karaba/features/car_management/domain/usecases/get_owner_cars_use_case.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GetOwnerCarsParamsModel extends GetOwnerCarsParams {
  const GetOwnerCarsParamsModel({
    required super.take,
    required super.skip,
    super.brand,
    super.model,
    super.city,
    super.transmission,
    super.minPrice,
    super.maxPrice,
    super.status,
    super.availableOnly,
  });

  factory GetOwnerCarsParamsModel.fromEntity(GetOwnerCarsParams entity) =>
      GetOwnerCarsParamsModel(
        take: entity.take,
        skip: entity.skip,
        brand: entity.brand,
        model: entity.model,
        city: entity.city,
        transmission: entity.transmission,
        minPrice: entity.minPrice,
        maxPrice: entity.maxPrice,
        status: entity.status,
        availableOnly: entity.availableOnly,
      );

  PostgrestFilterBuilder applyFilters(PostgrestFilterBuilder query) {
    var filteredQuery = query;

    if (brand != null && brand!.isNotEmpty) {
      filteredQuery = filteredQuery.ilike('brand', '%$brand%');
    }
    if (model != null && model!.isNotEmpty) {
      filteredQuery = filteredQuery.ilike('model', '%$model%');
    }

    if (city != null && city!.isNotEmpty) {
      filteredQuery = filteredQuery.eq('city', city!);
    }

    if (status != null) {
      filteredQuery = filteredQuery.eq('status', status!.name);
    }
    if (transmission != null) {
      filteredQuery = filteredQuery.eq('transmission', transmission!.name);
    }

    if (minPrice != null) {
      filteredQuery = filteredQuery.gte('price_per_day', minPrice!);
    }
    if (maxPrice != null) {
      filteredQuery = filteredQuery.lte('price_per_day', maxPrice!);
    }

    if (availableOnly == true) {
      filteredQuery = filteredQuery.eq('status', 'verified');
    }

    filteredQuery.range(skip, skip + take - 1);

    return filteredQuery;
  }
}
