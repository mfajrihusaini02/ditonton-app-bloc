import 'package:ditonton/domain/entities/movie/movie_detail.dart';
import 'package:equatable/equatable.dart';

abstract class DetailMovieState extends Equatable {
  const DetailMovieState();

  @override
  List<Object?> get props => [];
}

class DetailMovieLoading extends DetailMovieState {}

class DetailMovieEmpty extends DetailMovieState {}

class DetailMovieError extends DetailMovieState {
  final String message;

  const DetailMovieError(this.message);

  @override
  List<Object?> get props => [message];
}

class DetailMovieLoaded extends DetailMovieState {
  final MovieDetail result;

  const DetailMovieLoaded(this.result);

  @override
  List<Object?> get props => [result];
}