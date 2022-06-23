part of 'detail_tv_bloc.dart';

abstract class DetailTvState extends Equatable {
  const DetailTvState();

  @override
  List<Object> get props => [];
}

class DetailTvEmpty extends DetailTvState {}

class DetailTvLoading extends DetailTvState {}

class DetailTvError extends DetailTvState {
  final String message;

  const DetailTvError(this.message);

  @override
  List<Object> get props => [message];
}

class DetailTvLoaded extends DetailTvState {
  final TvDetail result;

  const DetailTvLoaded(this.result);

  @override
  List<Object> get props => [result];
}
