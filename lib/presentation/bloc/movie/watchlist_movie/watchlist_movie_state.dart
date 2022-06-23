part of 'watchlist_movie_bloc.dart';

abstract class WatchlistMovieState extends Equatable {
  const WatchlistMovieState();

  @override
  List<Object> get props => [];
}

class WatchlistMovieEmpty extends WatchlistMovieState {}

class WatchlistMovieLoading extends WatchlistMovieState {}

class WatchlistMovieError extends WatchlistMovieState {
  final String message;

  const WatchlistMovieError(this.message);

  @override
  List<Object> get props => [message];
}

class WatchlistMovieSuccess extends WatchlistMovieState {
  final String message;

  const WatchlistMovieSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class WatchlistMovieLoaded extends WatchlistMovieState {
  final List<Movie> result;

  const WatchlistMovieLoaded(this.result);

  @override
  List<Object> get props => [result];
}

class WatchlistStatusMovieLoaded extends WatchlistMovieState {
  final bool result;

  const WatchlistStatusMovieLoaded(this.result);

  @override
  List<Object> get props => [result];
}
