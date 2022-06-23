part of 'recommendation_movie_bloc.dart';

abstract class RecommendationMovieState extends Equatable {
  const RecommendationMovieState();
  
  @override
  List<Object> get props => [];
}

class RecommendationMovieEmpty extends RecommendationMovieState {}

class RecommendationMovieLoading extends RecommendationMovieState {}

class RecommendationMovieError extends RecommendationMovieState {
  final String message;

  const RecommendationMovieError(this.message);

  @override
  List<Object> get props => [message];
}

class RecommendationMovieLoaded extends RecommendationMovieState {
  final List<Movie> movie;

  const RecommendationMovieLoaded(this.movie);

  @override
  List<Object> get props => [movie];
}
