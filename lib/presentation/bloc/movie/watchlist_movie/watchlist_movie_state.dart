part of 'watchlist_movie_bloc.dart';

abstract class WatchlistMovieState extends Equatable {
  const WatchlistMovieState();
  
  @override
  List<Object> get props => [];
}

class WatchlistMovieInitial extends WatchlistMovieState {}
