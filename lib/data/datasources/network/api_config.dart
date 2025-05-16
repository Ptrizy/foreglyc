import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  String get baseUrl => dotenv.env['BASE_URL']!;

  String get signUp => "$baseUrl/api/v1/auth/signup";
  String get signIn => "$baseUrl/api/v1/auth/signin";

  String get chatbotForeglycExport =>
      "$baseUrl/api/v1/chatbots/foreglyc-expert";

  String get uploadFile => "$baseUrl/api/v1/files/upload";

  String get createMonitoringGlucoseGlucometer =>
      "$baseUrl/api/v1/monitorings/glucometers";
  String get getMonitoringGlucoseGlucometer =>
      "$baseUrl/api/v1/monitorings/glucometers";
  String getMonitoringGlucoseGlucometerGraph(String type) =>
      "$baseUrl/api/v1/monitorings/glucometers/graph?type=$type";

  String get createGlucometerMonitoringPreferences =>
      '$baseUrl/api/v1/monitorings/glucometers/preferences';
  String get createCgmMonitoringPreferences =>
      '$baseUrl/api/v1/monitorings/cgm/preferences';

  String get getHomepage => "$baseUrl/api/v1/homepages/self";
  // sisanya construct URL langsung di repository impl
}
