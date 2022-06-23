import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/movie/movie.dart';
import 'package:ditonton/domain/usecases/movie/get_popular_movies.dart';
import 'package:equatable/equatable.dart';

part 'popular_movie_event.dart';
part 'popular_movie_state.dart';

class PopularMovieBloc extends Bloc<PopularMovieEvent, PopularMovieState> {
  final GetPopularMovies getPopularMovies;

  PopularMovieBloc(
      this.getPopularMovies,
      ) : super(PopularMovieEmpty()) {
    on<FetchPopularMovieEvent>((event, emit) async {
      emit(PopularMovieLoading());
      final result = await getPopularMovies.execute();
      result.fold(
            (failure) {
          emit(PopularMovieError(failure.message));
        },
            (data) {
          emit(PopularMovieLoaded(data));
        },
      );
    });
  }
}
