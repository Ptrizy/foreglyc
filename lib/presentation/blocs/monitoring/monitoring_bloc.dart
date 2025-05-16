import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foreglyc/data/repositories/monitoring_repository.dart';
import 'package:foreglyc/presentation/blocs/monitoring/monitoring_event.dart';
import 'package:foreglyc/presentation/blocs/monitoring/monitoring_state.dart';

class MonitoringBloc extends Bloc<MonitoringEvent, MonitoringState> {
  final MonitoringRepository _monitoringRepository;

  MonitoringBloc({required MonitoringRepository monitoringRepository})
    : _monitoringRepository = monitoringRepository,
      super(MonitoringInitial()) {
    on<CreateGlucometerMonitoringEvent>(_onCreateGlucometerMonitoring);
    on<GetGlucometerMonitoringEvent>(_onGetGlucometerMonitoring);
    on<GetGlucometerMonitoringGraphEvent>(_onGetGlucometerMonitoringGraph);
  }

  Future<void> _onCreateGlucometerMonitoring(
    CreateGlucometerMonitoringEvent event,
    Emitter<MonitoringState> emit,
  ) async {
    emit(MonitoringLoading(isGraphLoading: true, isListLoading: true));
    try {
      await _monitoringRepository.createMonitoringGlucoseGlucometer(
        event.bloodGlucose,
      );
      emit(MonitoringInitial());
    } catch (e) {
      emit(
        MonitoringError(
          message: e.toString(),
          isGraphError: true,
          isListError: true,
        ),
      );
    }
  }

  Future<void> _onGetGlucometerMonitoring(
    GetGlucometerMonitoringEvent event,
    Emitter<MonitoringState> emit,
  ) async {
    // Determine if graph is loading based on the current state
    bool isGraphLoading = false;
    if (state is MonitoringLoading) {
      isGraphLoading = (state as MonitoringLoading).isGraphLoading;
    }

    emit(
      MonitoringLoading(isGraphLoading: isGraphLoading, isListLoading: true),
    );

    try {
      final response =
          await _monitoringRepository.getMonitoringGlucoseGlucometer();
      emit(MonitoringListLoaded(response));
    } catch (e) {
      emit(
        MonitoringError(
          message: e.toString(),
          isListError: true,
          isGraphError: isGraphLoading,
        ),
      );
    }
  }

  Future<void> _onGetGlucometerMonitoringGraph(
    GetGlucometerMonitoringGraphEvent event,
    Emitter<MonitoringState> emit,
  ) async {
    bool isListLoading = false;
    if (state is MonitoringLoading) {
      isListLoading = (state as MonitoringLoading).isListLoading;
    }

    emit(MonitoringLoading(isGraphLoading: true, isListLoading: isListLoading));

    try {
      final response = await _monitoringRepository
          .getMonitoringGlucoseGlucometerGraph(event.type);
      emit(MonitoringGraphLoaded(response));
    } catch (e) {
      emit(
        MonitoringError(
          message: e.toString(),
          isGraphError: true,
          isListError: isListLoading,
        ),
      );
    }
  }
}
