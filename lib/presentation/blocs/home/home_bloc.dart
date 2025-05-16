import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:foreglyc/data/models/home_model.dart';
import 'package:foreglyc/data/repositories/home_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository _repository;

  HomeBloc({required HomeRepository repository})
    : _repository = repository,
      super(HomeInitial()) {
    on<FetchHomeData>(_onFetchHomeData);
  }

  Future<void> _onFetchHomeData(
    FetchHomeData event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());
    try {
      final response = await _repository.getHomeData();
      emit(HomeLoaded(response));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }
}
