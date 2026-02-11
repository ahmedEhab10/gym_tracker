import 'package:equatable/equatable.dart';
import 'package:try_my_tracker/domain/entities/program.dart';
import 'package:try_my_tracker/domain/entities/training_day.dart';

abstract class ProgramEvent extends Equatable {
  const ProgramEvent();

  @override
  List<Object?> get props => [];
}

class LoadAllPrograms extends ProgramEvent {}

class CreateProgramEvent extends ProgramEvent {
  final String name;
  final String description;

  const CreateProgramEvent({required this.name, required this.description});
}

class UpdateProgramEvent extends ProgramEvent {
  final Program program;

  const UpdateProgramEvent({required this.program});
}

class DeleteProgramEvent extends ProgramEvent {
  final String id;

  const DeleteProgramEvent({required this.id});
}

class LoadProgramDetails extends ProgramEvent {
  final String programId;

  const LoadProgramDetails({required this.programId});
}

class AddTrainingDayToProgram extends ProgramEvent {
  final String programId;
  final String name;

  const AddTrainingDayToProgram({required this.programId, required this.name});
}

class DeleteTrainingDayEvent extends ProgramEvent {
  final String trainingDayId;
  final String programId;

  const DeleteTrainingDayEvent({
    required this.trainingDayId,
    required this.programId,
  });
}
