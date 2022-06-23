import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/movie/movie.dart';
import 'package:ditonton/domain/usecases/movie/get_now_playing_movies.dart';
import 'package:equatable/equatable.dart';

part 'now_playing_movie_event.dart';
part 'now_playing_movie_state.dart';

class NowPlayingMovieBloc
    extends Bloc<NowPlayingMovieEvent, NowPlayingMovieState> {
  final GetNowPlayingMovies getNowPlayingMovies;

  NowPlayingMovieBloc(this.getNowPlayingMovies)
      : super(NowPlayingMovieEmpty()) {
    on<FetchNowPlayingMovieEvent>((event, emit) async {
      emit(NowPlayingMovieLoading());

      final result = await getNowPlayingMovies.execute();
      result.fold((failure) {
        emit(NowPlayingMovieError(failure.message));
      }, (hasData) {
        emit(NowPlayingMovieLoaded(hasData));
      });
    });
  }
}
