import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:foreglyc/data/models/food_information_model.dart';
import 'package:foreglyc/data/models/food_monitoring_model.dart';
import 'package:foreglyc/data/repositories/dietary_repository.dart';

part 'food_recall_event.dart';
part 'food_recall_state.dart';

class FoodRecallBloc extends Bloc<FoodRecallEvent, FoodRecallState> {
  final DietaryRepository dietaryRepository;

  FoodRecallBloc({required this.dietaryRepository})
    : super(FoodRecallInitial()) {
    on<UploadFoodImage>(_onUploadFoodImage);
    on<GenerateFoodInformation>(_onGenerateFoodInformation);
    on<CreateFoodMonitoring>(_onCreateFoodMonitoring);
  }

  Future<void> _onUploadFoodImage(
    UploadFoodImage event,
    Emitter<FoodRecallState> emit,
  ) async {
    emit(FoodRecallLoading());
    try {
      final response = await dietaryRepository.uploadFile(event.imageFile);
      emit(FoodImageUploaded(response.data.url));
    } catch (e) {
      emit(FoodRecallError('Failed to upload image: ${e.toString()}'));
    }
  }

  Future<void> _onGenerateFoodInformation(
    GenerateFoodInformation event,
    Emitter<FoodRecallState> emit,
  ) async {
    emit(FoodRecallLoading());
    try {
      final response = await dietaryRepository.generateFoodInformation(
        mealTime: event.mealTime,
        imageUrl: event.imageUrl,
      );
      emit(FoodInformationGenerated(response.data));
    } catch (e) {
      emit(
        FoodRecallError('Failed to generate food information: ${e.toString()}'),
      );
    }
  }

  Future<void> _onCreateFoodMonitoring(
    CreateFoodMonitoring event,
    Emitter<FoodRecallState> emit,
  ) async {
    emit(FoodRecallLoading());
    try {
      final response = await dietaryRepository.createFoodMonitoring(
        foodName: event.foodName,
        mealTime: event.mealTime,
        imageUrl: event.imageUrl,
        nutritions: event.nutritions,
        totalCalory: event.totalCalory,
        totalCarbohydrate: event.totalCarbohydrate,
        totalProtein: event.totalProtein,
        totalFat: event.totalFat,
        glyecemicIndex: event.glyecemicIndex,
      );
      emit(FoodMonitoringCreated(response.data));
    } catch (e) {
      emit(
        FoodRecallError('Failed to create food monitoring: ${e.toString()}'),
      );
    }
  }
}
