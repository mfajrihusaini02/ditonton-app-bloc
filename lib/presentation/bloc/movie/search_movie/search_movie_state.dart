part of 'search_movie_bloc.dart';

abstract class SearchMovieState extends Equatable {
  const SearchMovieState();

  @override
  List<Object> get props => [];
}

class SearchMovieEmpty extends SearchMovieState {}

class SearchMovieLoading extends SearchMovieState {}

class SearchMovieError extends SearchMovieState {
  final String message;

  SearchMovieError(this.message);

  @override
  List<Object> get props => [message];
}

class SearchMovieLoaded extends SearchMovieState {
  final List<Movie> result;

  const SearchMovieLoaded(this.result);

  @override
  List<Object> get props => [result];
}

class SearchMovieHasData extends SearchMovieState {
  final List<Movie> result;

  SearchMovieHasData(this.result);

  @override
  List<Object> get props => [result];
}
