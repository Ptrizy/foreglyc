import 'package:foreglyc/data/models/monitoring_model.dart';

abstract class MonitoringRepository {
  Future<CreateMonitoringGlucoseResponse> createMonitoringGlucoseGlucometer(
    int bloodGlucose,
  );
  Future<GetMonitoringGlucoseResponse> getMonitoringGlucoseGlucometer();

  Future<GetMonitoringGlucoseGraphResponse> getMonitoringGlucoseGlucometerGraph(
    String type,
  );
}
