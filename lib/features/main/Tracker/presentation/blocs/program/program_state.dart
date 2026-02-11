import 'package:equatable/equatable.dart';
import 'package:try_my_tracker/domain/entities/program.dart';
import 'package:try_my_tracker/domain/entities/training_day.dart';

abstract class ProgramState extends Equatable {
  const ProgramState();

  @override
  List<Object?> get props => [];
}

class ProgramInitial extends ProgramState {}

class ProgramLoading extends ProgramState {}

class ProgramLoaded extends ProgramState {
  final List<Program> programs;

  const ProgramLoaded({required this.programs});

  @override
  List<Object?> get props => [programs];
}

class ProgramDetailLoaded extends ProgramState {
  final Program program;
  final List<TrainingDay> trainingDays;

  const ProgramDetailLoaded({
    required this.program,
    required this.trainingDays,
  });

  @override
  List<Object?> get props => [program, trainingDays];
}

class ProgramError extends ProgramState {
  final String message;

  const ProgramError({required this.message});

  @override
  List<Object?> get props => [message];
}
