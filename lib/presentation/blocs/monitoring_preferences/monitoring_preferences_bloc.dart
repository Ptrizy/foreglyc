import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:foreglyc/data/models/monitoring_preference_model.dart';
import 'package:foreglyc/data/repositories/monitoring_preferences_repository.dart';

part 'monitoring_preferences_event.dart';
part 'monitoring_preferences_state.dart';

class MonitoringPreferenceBloc
    extends Bloc<MonitoringPreferenceEvent, MonitoringPreferenceState> {
  final MonitoringPreferenceRepository _repository;

  MonitoringPreferenceBloc({required MonitoringPreferenceRepository repository})
    : _repository = repository,
      super(MonitoringPreferenceInitial()) {
    on<CreateGlucometerPreferenceEvent>(_onCreateGlucometerPreference);
    on<CreateCgmPreferenceEvent>(_onCreateCgmPreference);
  }

  Future<void> _onCreateGlucometerPreference(
    CreateGlucometerPreferenceEvent event,
    Emitter<MonitoringPreferenceState> emit,
  ) async {
    emit(MonitoringPreferenceLoading());
    try {
      final response = await _repository.createGlucometerPreference(
        startWakeUpTime: event.startWakeUpTime,
        endWakeUpTime: event.endWakeUpTime,
        physicalActivityDays: event.physicalActivityDays,
        startSleepTime: event.startSleepTime,
        endSleepTime: event.endSleepTime,
        hypoglycemiaAccuteThreshold: event.hypoglycemiaAccuteThreshold,
        hypoglycemiaChronicThreshold: event.hypoglycemiaChronicThreshold,
        hyperglycemiaAccuteThreshold: event.hyperglycemiaAccuteThreshold,
        hyperglycemiaChronicThreshold: event.hyperglycemiaChronicThreshold,
        sendNotification: event.sendNotification,
      );
      emit(GlucometerPreferenceCreated(response));
    } catch (e) {
      emit(MonitoringPreferenceError(e.toString()));
    }
  }

  Future<void> _onCreateCgmPreference(
    CreateCgmPreferenceEvent event,
    Emitter<MonitoringPreferenceState> emit,
  ) async {
    emit(MonitoringPreferenceLoading());
    try {
      final response = await _repository.createCgmPreference(
        physicalActivityDays: event.physicalActivityDays,
        hypoglycemiaAccuteThreshold: event.hypoglycemiaAccuteThreshold,
        hypoglycemiaChronicThreshold: event.hypoglycemiaChronicThreshold,
        hyperglycemiaAccuteThreshold: event.hyperglycemiaAccuteThreshold,
        hyperglycemiaChronicThreshold: event.hyperglycemiaChronicThreshold,
        sendNotification: event.sendNotification,
      );
      emit(CgmPreferenceCreated(response));
    } catch (e) {
      emit(MonitoringPreferenceError(e.toString()));
    }
  }
}
