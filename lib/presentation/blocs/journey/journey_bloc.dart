import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'journey_event.dart';
part 'journey_state.dart';

class JourneyBloc extends Bloc<JourneyEvent, JourneyState> {
  JourneyBloc() : super(JourneyInitial()) {
    on<JourneyEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
