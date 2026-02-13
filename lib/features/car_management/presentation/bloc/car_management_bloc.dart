import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karaba/core/common/entities/car_entity.dart';
import 'package:karaba/core/common/entities/document_entity.dart';
import 'package:karaba/features/car_management/domain/entities/car_form_entity.dart';
import 'package:karaba/features/car_management/domain/usecases/add_car_use_case.dart';
import 'package:karaba/features/car_management/domain/usecases/delete_car_use_case.dart';
import 'package:karaba/features/car_management/domain/usecases/get_car_details_use_case.dart';
import 'package:karaba/features/car_management/domain/usecases/get_car_documents_use_case.dart';
import 'package:karaba/features/car_management/domain/usecases/get_owner_cars_use_case.dart';
import 'package:karaba/features/car_management/domain/usecases/update_car_use_case.dart';

part 'car_management_event.dart';
part 'car_management_state.dart';

class CarManagementBloc extends Bloc<CarManagementEvent, CarManagementState> {
  final GetOwnerCarsUseCase _getOwnerCars;
  final GetCarDetailsUseCase _getCarDetails;
  final AddCarUseCase _addCar;
  final UpdateCarUseCase _updateCar;
  final DeleteCarUseCase _deleteCar;
  final GetCarDocumentsUseCase _getCarDocuments;
  CarManagementBloc({
    required GetOwnerCarsUseCase getOwnerCars,
    required GetCarDetailsUseCase getCarDetails,
    required AddCarUseCase addCar,
    required UpdateCarUseCase updateCar,
    required DeleteCarUseCase deleteCar,
    required GetCarDocumentsUseCase getCarDocuments,
  }) : _getOwnerCars = getOwnerCars,
       _getCarDetails = getCarDetails,
       _addCar = addCar,
       _updateCar = updateCar,
       _deleteCar = deleteCar,
       _getCarDocuments = getCarDocuments,
       super(const CarManagementState()) {
    on<FetchOwnerCars>(_onFetchOwnerCars);
    on<LoadMoreCars>(_onLoadMoreCars);
    on<RefreshCars>(_onRefreshCars);
    on<GetCarDetails>(_onGetCarDetails);
    on<AddCar>(_onAddCar);
    on<UpdateCar>(_onUpdateCar);
    on<DeleteCar>(_onDeleteCar);
    on<GetCarDocuments>(_onGetCarDocuments);
    on<ResetActionState>(_onResetActionState);
  }

  Future<void> _onFetchOwnerCars(
    FetchOwnerCars event,
    Emitter<CarManagementState> emit,
  ) async {
    final updatedParams = state.filters.copyWith(skip: 0);
    emit(
      state.copyWith(
        fetchStatus: CarManagementStatus.loading,
        filters: updatedParams,
      ),
    );

    final result = await _getOwnerCars.call(updatedParams);

    result.fold(
      (failure) => emit(
        state.copyWith(
          fetchStatus: CarManagementStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (response) => emit(
        state.copyWith(
          fetchStatus: CarManagementStatus.success,
          cars: response.items,
          totalCount: response.totalCount,
          hasNextPage: response.hasNextPage,
        ),
      ),
    );
  }

  Future<void> _onLoadMoreCars(
    LoadMoreCars event,
    Emitter<CarManagementState> emit,
  ) async {
    if (state.isLoadingMore || !state.hasNextPage) return;

    emit(state.copyWith(isLoadingMore: true, loadMoreError: null));

    final updatedParams = state.filters.copyWith(skip: state.cars.length);

    final result = await _getOwnerCars.call(updatedParams);

    result.fold(
      (failure) => emit(
        state.copyWith(isLoadingMore: false, loadMoreError: failure.message),
      ),
      (response) => emit(
        state.copyWith(
          isLoadingMore: false,
          cars: [...state.cars, ...response.items],
          totalCount: response.totalCount,
          hasNextPage: response.hasNextPage,
          filters: updatedParams,
        ),
      ),
    );
  }

  Future<void> _onRefreshCars(
    RefreshCars event,
    Emitter<CarManagementState> emit,
  ) async {
    final updatedParams = state.filters.copyWith(skip: 0);

    final result = await _getOwnerCars.call(updatedParams);

    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (response) => emit(
        state.copyWith(
          cars: response.items,
          totalCount: response.totalCount,
          hasNextPage: response.hasNextPage,
          filters: updatedParams,
        ),
      ),
    );
  }

  Future<void> _onAddCar(AddCar event, Emitter<CarManagementState> emit) async {
    emit(
      state.copyWith(
        actionStatus: CarManagementStatus.loading,
        lastAction: CarManagementActionType.create,
      ),
    );

    final result = await _addCar.call(event.formData);

    result.fold(
      (failure) => emit(
        state.copyWith(
          actionStatus: CarManagementStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (newCar) {
        final updatedList = [newCar, ...state.cars];

        emit(
          state.copyWith(
            cars: updatedList,
            actionStatus: CarManagementStatus.success,
            totalCount: state.totalCount + 1,
          ),
        );
      },
    );
  }

  Future<void> _onUpdateCar(
    UpdateCar event,
    Emitter<CarManagementState> emit,
  ) async {
    emit(
      state.copyWith(
        actionStatus: CarManagementStatus.loading,
        lastAction: CarManagementActionType.update,
      ),
    );

    final result = await _updateCar.call(event.formData);

    result.fold(
      (failure) => emit(
        state.copyWith(
          actionStatus: CarManagementStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (updatedCar) {
        final updatedList = state.cars
            .map((car) => car.id == updatedCar.id ? updatedCar : car)
            .toList();
        emit(
          state.copyWith(
            cars: updatedList,
            actionStatus: CarManagementStatus.success,
          ),
        );
      },
    );
  }

  Future<void> _onDeleteCar(
    DeleteCar event,
    Emitter<CarManagementState> emit,
  ) async {
    emit(
      state.copyWith(
        actionStatus: CarManagementStatus.loading,
        lastAction: CarManagementActionType.delete,
      ),
    );

    final result = await _deleteCar.call(event.carId);

    result.fold(
      (failure) => emit(
        state.copyWith(
          actionStatus: CarManagementStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (_) {
        final updatedList = List<CarEntity>.from(state.cars);

        updatedList.removeWhere((car) => car.id == event.carId);

        emit(
          state.copyWith(
            cars: updatedList,
            actionStatus: CarManagementStatus.success,
            totalCount: state.totalCount - 1,
          ),
        );
      },
    );
  }

  Future<void> _onGetCarDetails(
    GetCarDetails event,
    Emitter<CarManagementState> emit,
  ) async {
    emit(state.copyWith(actionStatus: CarManagementStatus.loading));

    final result = await _getCarDetails.call(event.carId);

    result.fold(
      (failure) => emit(
        state.copyWith(
          actionStatus: CarManagementStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (car) {
        emit(
          state.copyWith(
            selectedCar: car,
            actionStatus: CarManagementStatus.success,
          ),
        );
      },
    );
  }

  Future<void> _onGetCarDocuments(
    GetCarDocuments event,
    Emitter<CarManagementState> emit,
  ) async {
    emit(state.copyWith(actionStatus: CarManagementStatus.loading));

    final result = await _getCarDocuments.call(event.carId);

    result.fold(
      (failure) => emit(
        state.copyWith(
          actionStatus: CarManagementStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (docs) {
        emit(
          state.copyWith(
            carDocuments: docs,
            actionStatus: CarManagementStatus.success,
          ),
        );
      },
    );
  }

  void _onResetActionState(
    ResetActionState event,
    Emitter<CarManagementState> emit,
  ) {
    emit(
      state.copyWith(
        actionStatus: CarManagementStatus.initial,
        errorMessage: null,
        loadMoreError: null,
      ),
    );
  }
}
