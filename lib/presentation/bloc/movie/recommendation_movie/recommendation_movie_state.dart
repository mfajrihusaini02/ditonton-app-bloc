part of 'recommendation_movie_bloc.dart';

abstract class RecommendationMovieState extends Equatable {
  const RecommendationMovieState();
  
  @override
  List<Object> get props => [];
}

class RecommendationMovieInitial extends RecommendationMovieState {}
