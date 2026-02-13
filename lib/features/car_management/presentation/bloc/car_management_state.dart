part of 'car_management_bloc.dart';

enum CarManagementStatus { initial, loading, success, failure }

enum CarManagementActionType { create, update, delete }

class CarManagementState extends Equatable {
  final List<CarEntity> cars;
  final CarEntity? selectedCar;
  final List<DocumentEntity> carDocuments;

  final CarManagementStatus fetchStatus;
  final CarManagementStatus actionStatus;
  final CarManagementActionType? lastAction;

  final GetOwnerCarsParams filters;

  final int totalCount;
  final bool hasNextPage;
  final bool isLoadingMore;
  final String? loadMoreError;

  final String? errorMessage;

  const CarManagementState({
    this.cars = const [],
    this.selectedCar,
    this.carDocuments = const [],
    this.fetchStatus = CarManagementStatus.initial,
    this.actionStatus = CarManagementStatus.initial,
    this.lastAction,
    this.filters = const GetOwnerCarsParams(),
    this.totalCount = 0,
    this.hasNextPage = false,
    this.isLoadingMore = false,
    this.loadMoreError,
    this.errorMessage,
  });

  CarManagementState copyWith({
    List<CarEntity>? cars,
    CarEntity? selectedCar,
    List<DocumentEntity>? carDocuments,
    CarManagementStatus? fetchStatus,
    CarManagementStatus? actionStatus,
    CarManagementActionType? lastAction,
    GetOwnerCarsParams? filters,
    int? totalCount,
    bool? hasNextPage,
    bool? isLoadingMore,
    String? loadMoreError,
    String? errorMessage,
  }) {
    return CarManagementState(
      cars: cars ?? this.cars,
      selectedCar: selectedCar ?? this.selectedCar,
      carDocuments: carDocuments ?? this.carDocuments,
      fetchStatus: fetchStatus ?? this.fetchStatus,
      actionStatus: actionStatus ?? this.actionStatus,
      lastAction: lastAction ?? this.lastAction,
      filters: filters ?? this.filters,
      totalCount: totalCount ?? this.totalCount,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      loadMoreError: loadMoreError ?? this.loadMoreError,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    cars,
    selectedCar,
    carDocuments,
    fetchStatus,
    actionStatus,
    lastAction,
    filters,
    totalCount,
    hasNextPage,
    isLoadingMore,
    loadMoreError,
    errorMessage,
  ];
}
