part of 'search_movie_bloc.dart';

abstract class SearchMovieEvent extends Equatable {
  const SearchMovieEvent();

  @override
  List<Object> get props => [];
}

class SearchMovieSetEmpty extends SearchMovieEvent {}

class OnQueryChangedMovie extends SearchMovieEvent {
  final String query;

  OnQueryChangedMovie(this.query);

  @override
  List<Object> get props => [query];
}
