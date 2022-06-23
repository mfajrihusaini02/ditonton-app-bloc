part of 'top_rated_movie_bloc.dart';

abstract class TopRatedMovieState extends Equatable {
  const TopRatedMovieState();

  @override
  List<Object> get props => [];
}

class TopRatedMovieEmpty extends TopRatedMovieState {}

class TopRatedMovieLoading extends TopRatedMovieState {}

class TopRatedMovieError extends TopRatedMovieState {
  final String message;

  const TopRatedMovieError(this.message);

  @override
  List<Object> get props => [message];
}

class TopRatedMovieLoaded extends TopRatedMovieState {
  final List<Movie> result;

  const TopRatedMovieLoaded(this.result);

  @override
  List<Object> get props => [result];
}
