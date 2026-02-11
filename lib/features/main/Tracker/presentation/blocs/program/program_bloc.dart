import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:try_my_tracker/core/usecases/usecase.dart';
import 'package:try_my_tracker/domain/entities/program.dart';
import 'package:try_my_tracker/domain/entities/training_day.dart';
import 'package:uuid/uuid.dart';

import '../../../../../../domain/usecases/program/program_usecases.dart';
import 'program_event.dart';
import 'program_state.dart';

class ProgramBloc extends Bloc<ProgramEvent, ProgramState> {
  final GetPrograms getPrograms;
  final CreateProgram createProgram;
  final UpdateProgram updateProgram;
  final DeleteProgram deleteProgram;
  final GetTrainingDaysForProgram getTrainingDaysForProgram;
  final AddTrainingDay addTrainingDay;
  final DeleteTrainingDay deleteTrainingDay;
  final Uuid uuid;

  ProgramBloc({
    required this.getPrograms,
    required this.createProgram,
    required this.updateProgram,
    required this.deleteProgram,
    required this.getTrainingDaysForProgram,
    required this.addTrainingDay,
    required this.deleteTrainingDay,
    required this.uuid,
  }) : super(ProgramInitial()) {
    on<LoadAllPrograms>(_onLoadAllPrograms);
    on<CreateProgramEvent>(_onCreateProgram);
    on<DeleteProgramEvent>(_onDeleteProgram);
    on<LoadProgramDetails>(_onLoadProgramDetails);
    on<AddTrainingDayToProgram>(_onAddTrainingDayToProgram);
    on<DeleteTrainingDayEvent>(_onDeleteTrainingDay);
  }

  Future<void> _onLoadAllPrograms(
    LoadAllPrograms event,
    Emitter<ProgramState> emit,
  ) async {
    emit(ProgramLoading());
    final result = await getPrograms(NoParams());
    result.fold(
      (failure) => emit(ProgramError(message: _mapFailureToMessage(failure))),
      (programs) => emit(ProgramLoaded(programs: programs)),
    );
  }

  Future<void> _onCreateProgram(
    CreateProgramEvent event,
    Emitter<ProgramState> emit,
  ) async {
    // Current state might be Loaded or Initial, but we want to stay there and just reload after create
    // Or optimistically update
    final newProgram = Program(
      id: uuid.v4(),
      name: event.name,
      description: event.description,
      trainingDayIds: [],
      isActive: false, // Default not active
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final result = await createProgram(newProgram);
    result.fold(
      (failure) => emit(ProgramError(message: _mapFailureToMessage(failure))),
      (_) => add(LoadAllPrograms()), // Reload list
    );
  }

  Future<void> _onDeleteProgram(
    DeleteProgramEvent event,
    Emitter<ProgramState> emit,
  ) async {
    final result = await deleteProgram(event.id);
    result.fold(
      (failure) => emit(ProgramError(message: _mapFailureToMessage(failure))),
      (_) => add(LoadAllPrograms()), // Reload list
    );
  }

  Future<void> _onLoadProgramDetails(
    LoadProgramDetails event,
    Emitter<ProgramState> emit,
  ) async {
    emit(ProgramLoading());
    // We need both the program info and its days
    // But getPrograms returns a list. Maybe we need getProgram(id)
    // Assuming we passed the Program object or fetched it.
    // For now, let's just fetch days. To really support this properly we might need GetProgramById usecase
    // But usually we navigate from the list so let's check how to handle this.
    // I can reuse LoadAllPrograms to find it, or assume I have it.
    // Let's implement fetching days first.

    final daysResult = await getTrainingDaysForProgram(event.programId);

    // TEMPORARY: Need to get program details too.
    // Since I don't have GetProgramById injected, I will assume the caller might pass the program or I need to add that use case.
    // Actually, `getPrograms` returns all. I can filter? No that's inefficient.
    // For now, check if I can add GetProgramById. I see it in repository.
    // I'll skip fetching the Program object again if I assume it's passed,
    // BUT the state needs it.
    // Let's fetch the list and find it? Or just instantiate a dummy?
    // Proper way: Inject GetProgramById.
    // Quick fix for now: Fetch all and find. (Low performance but works for small app)

    await getPrograms(NoParams());

    // This is messy. Let's fix the constructor to accept GetProgramById if needed,
    // OR just rely on the previous state if it was loaded.
    // Let's assume we are in ProgramLoaded state and we navigate.
    // But `ProgramDetailLoaded` needs the `Program` object.

    // Better: Allow `ProgramDetailLoaded` to accept just the days and we pass the Program object in the event?
    // No, data consistency.

    // Let's assume for now we just load days.
    // Wait, the repository has `getProgram(id)`.
    // I check `program_usecases.dart`...

    await daysResult.fold(
      (failure) async =>
          emit(ProgramError(message: _mapFailureToMessage(failure))),
      (days) async {
        final allProgramsResult = await getPrograms(NoParams());
        allProgramsResult.fold(
          (f) => emit(ProgramError(message: _mapFailureToMessage(f))),
          (list) {
            try {
              final program = list.firstWhere((p) => p.id == event.programId);
              emit(ProgramDetailLoaded(program: program, trainingDays: days));
            } catch (e) {
              emit(const ProgramError(message: "Program not found"));
            }
          },
        );
      },
    );
  }

  Future<void> _onAddTrainingDayToProgram(
    AddTrainingDayToProgram event,
    Emitter<ProgramState> emit,
  ) async {
    final dayId = uuid.v4();
    final newDay = TrainingDay(
      id: dayId,
      programId: event.programId,
      name: event.name,
      dayOfWeek: 0, // Not used for custom routes
      exerciseIds: [],
      orderIndex: DateTime.now().millisecondsSinceEpoch, // Simple ordering
    );

    final result = await addTrainingDay(newDay);
    result.fold(
      (failure) => emit(ProgramError(message: _mapFailureToMessage(failure))),
      (_) => add(LoadProgramDetails(programId: event.programId)),
    );
  }

  Future<void> _onDeleteTrainingDay(
    DeleteTrainingDayEvent event,
    Emitter<ProgramState> emit,
  ) async {
    final result = await deleteTrainingDay(event.trainingDayId);
    result.fold(
      (failure) => emit(ProgramError(message: _mapFailureToMessage(failure))),
      (_) => add(LoadProgramDetails(programId: event.programId)),
    );
  }

  String _mapFailureToMessage(dynamic failure) {
    return 'Unexpected Error';
  }
}
