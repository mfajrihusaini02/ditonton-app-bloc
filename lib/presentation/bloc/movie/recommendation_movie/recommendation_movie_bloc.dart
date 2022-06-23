import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/movie/movie.dart';
import 'package:ditonton/domain/usecases/movie/get_movie_recommendations.dart';
import 'package:equatable/equatable.dart';

part 'recommendation_movie_event.dart';
part 'recommendation_movie_state.dart';

class RecommendationMovieBloc
    extends Bloc<RecommendationMovieEvent, RecommendationMovieState> {
  final GetMovieRecommendations getMovieRecommendations;

  RecommendationMovieBloc(this.getMovieRecommendations)
      : super(RecommendationMovieEmpty()) {
    on<FetchRecommendationMovieEvent>((event, emit) async {
      emit(RecommendationMovieLoading());
      final result = await getMovieRecommendations.execute(event.id);
      result.fold(
        (failure) {
          emit(RecommendationMovieError(failure.message));
        },
        (data) {
          emit(RecommendationMovieLoaded(data));
        },
      );
    });
  }
}
