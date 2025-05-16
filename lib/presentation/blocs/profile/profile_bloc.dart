import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foreglyc/data/datasources/local/home_preference.dart';

class ProfileBloc extends Cubit<Map<String, String?>> {
  final HomePreferences _homePreferences;

  ProfileBloc(this._homePreferences) : super({}) {
    loadProfile();
  }

  Future<void> loadProfile() async {
    try {
      final profileData = await _homePreferences.loadHome();
      emit(profileData);
    } catch (e) {
      emit({'error': e.toString()});
    }
  }
}
