part of 'top_rated_movie_bloc.dart';

abstract class TopRatedMovieState extends Equatable {
  const TopRatedMovieState();
  
  @override
  List<Object> get props => [];
}

class TopRatedMovieInitial extends TopRatedMovieState {}
