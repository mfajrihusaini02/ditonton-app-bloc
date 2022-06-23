part of 'recommendation_movie_bloc.dart';

abstract class RecommendationMovieEvent extends Equatable {
  const RecommendationMovieEvent();

  @override
  List<Object> get props => [];
}

class FetchRecommendationMovieEvent extends RecommendationMovieEvent {
  final int id;

  const FetchRecommendationMovieEvent(this.id);

  @override
  List<Object> get props => [id];
}
