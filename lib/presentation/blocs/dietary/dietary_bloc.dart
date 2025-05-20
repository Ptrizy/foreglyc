import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:foreglyc/data/datasources/logger.dart';
import 'package:foreglyc/data/models/food_home_model.dart';
import 'package:foreglyc/data/repositories/food_repository.dart';

part 'dietary_event.dart';
part 'dietary_state.dart';

class DietaryBloc extends Bloc<DietaryEvent, DietaryState> {
  final FoodRepository foodRepository;

  DietaryBloc({required this.foodRepository}) : super(DietaryInitial()) {
    on<LoadDietaryData>(_onLoadDietaryData);
  }

  Future<void> _onLoadDietaryData(
    LoadDietaryData event,
    Emitter<DietaryState> emit,
  ) async {
    emit(DietaryLoading());
    try {
      final response = await foodRepository.getFoodHomePage();
      AppLogger.debug(response.data.toString());
      emit(DietaryLoaded(response.data));
    } catch (e) {
      emit(DietaryError(e.toString()));
    }
  }
}
