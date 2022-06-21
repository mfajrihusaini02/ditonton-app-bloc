import 'package:equatable/equatable.dart';

abstract class DetailMovieEvent extends Equatable {
  const DetailMovieEvent();

  @override
  List<Object?> get props => [];
}

class FetchDetailMovieEvent extends DetailMovieEvent {
  final int id;

  FetchDetailMovieEvent(this.id);

  @override
  List<Object> get props => [id];
}
