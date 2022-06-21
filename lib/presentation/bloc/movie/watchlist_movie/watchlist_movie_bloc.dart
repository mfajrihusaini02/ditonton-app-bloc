import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'watchlist_movie_event.dart';
part 'watchlist_movie_state.dart';

class WatchlistMovieBloc extends Bloc<WatchlistMovieEvent, WatchlistMovieState> {
  WatchlistMovieBloc() : super(WatchlistMovieInitial()) {
    on<WatchlistMovieEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
