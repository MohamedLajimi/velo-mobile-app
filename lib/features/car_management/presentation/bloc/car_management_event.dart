part of 'car_management_bloc.dart';

abstract class CarManagementEvent extends Equatable {
  const CarManagementEvent();

  @override
  List<Object?> get props => [];
}

class FetchOwnerCars extends CarManagementEvent {
  final GetOwnerCarsParams params;

  const FetchOwnerCars({required this.params});

  @override
  List<Object?> get props => [params];
}

class LoadMoreCars extends CarManagementEvent {
  const LoadMoreCars();
}

class RefreshCars extends CarManagementEvent {
  const RefreshCars();
}

class GetCarDetails extends CarManagementEvent {
  final String carId;

  const GetCarDetails({required this.carId});

  @override
  List<Object?> get props => [carId];
}

class AddCar extends CarManagementEvent {
  final CarFormEntity formData;

  const AddCar({required this.formData});

  @override
  List<Object?> get props => [formData];
}

class UpdateCar extends CarManagementEvent {
  final CarFormEntity formData;

  const UpdateCar({required this.formData});

  @override
  List<Object?> get props => [formData];
}

class DeleteCar extends CarManagementEvent {
  final String carId;

  const DeleteCar({required this.carId});

  @override
  List<Object?> get props => [carId];
}

class GetCarDocuments extends CarManagementEvent {
  final String carId;

  const GetCarDocuments({required this.carId});

  @override
  List<Object?> get props => [carId];
}

class ResetActionState extends CarManagementEvent {
  const ResetActionState();
}
