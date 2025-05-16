import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:foreglyc/data/models/food_information_model.dart';
import 'package:foreglyc/data/repositories/dietary_repository.dart';

part 'food_information_event.dart';
part 'food_information_state.dart';

class FoodInformationBloc
    extends Bloc<FoodInformationEvent, FoodInformationState> {
  final DietaryRepository dietaryRepository;

  FoodInformationBloc({required this.dietaryRepository})
    : super(FoodInformationInitial()) {
    on<GenerateFoodInformation>(_onGenerateFoodInformation);
  }

  Future<void> _onGenerateFoodInformation(
    GenerateFoodInformation event,
    Emitter<FoodInformationState> emit,
  ) async {
    emit(FoodInformationLoading());
    try {
      final response = await dietaryRepository.generateFoodInformation(
        mealTime: event.mealTime,
        imageUrl: event.imageUrl,
      );
      emit(FoodInformationGenerated(response.data));
    } catch (e) {
      emit(FoodInformationError(e.toString()));
    }
  }
}
