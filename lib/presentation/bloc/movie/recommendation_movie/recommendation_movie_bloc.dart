import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'recommendation_movie_event.dart';
part 'recommendation_movie_state.dart';

class RecommendationMovieBloc extends Bloc<RecommendationMovieEvent, RecommendationMovieState> {
  RecommendationMovieBloc() : super(RecommendationMovieInitial()) {
    on<RecommendationMovieEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
