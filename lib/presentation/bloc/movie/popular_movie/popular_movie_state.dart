part of 'popular_movie_bloc.dart';

abstract class PopularMovieState extends Equatable {
  const PopularMovieState();
  
  @override
  List<Object> get props => [];
}

class PopularMovieEmpty extends PopularMovieState {}

class PopularMovieLoading extends PopularMovieState {}

class PopularMovieError extends PopularMovieState {
  final String message;

  const PopularMovieError(this.message);

  @override
  List<Object> get props => [message];
}

class PopularMovieLoaded extends PopularMovieState {
  final List<Movie> result;

  const PopularMovieLoaded(this.result);

  @override
  List<Object> get props => [result];
}
