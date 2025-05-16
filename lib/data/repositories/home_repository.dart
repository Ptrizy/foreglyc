import 'package:foreglyc/data/models/home_model.dart';

abstract class HomeRepository {
  Future<HomeResponse> getHomeData();
}
