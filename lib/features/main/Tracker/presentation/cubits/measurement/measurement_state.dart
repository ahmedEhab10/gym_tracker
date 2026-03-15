import 'package:equatable/equatable.dart';
import 'package:try_my_tracker/domain/entities/measurement_entity.dart';

abstract class MeasurementState extends Equatable {
  const MeasurementState();

  @override
  List<Object?> get props => [];
}

class MeasurementInitial extends MeasurementState {}

class MeasurementLoading extends MeasurementState {}

class MeasurementLoaded extends MeasurementState {
  final List<MeasurementEntity> measurements;

  const MeasurementLoaded(this.measurements);

  @override
  List<Object?> get props => [measurements];
}

class MeasurementError extends MeasurementState {
  final String message;

  const MeasurementError(this.message);

  @override
  List<Object?> get props => [message];
}

class MeasurementSaveSuccess extends MeasurementState {}
