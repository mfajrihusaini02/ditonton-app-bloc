part of 'on_the_air_tv_bloc.dart';

abstract class OnTheAirTvState extends Equatable {
  const OnTheAirTvState();

  @override
  List<Object> get props => [];
}

class OnTheAirTvEmpty extends OnTheAirTvState {}

class OnTheAirTvLoading extends OnTheAirTvState {}

class OnTheAirTvError extends OnTheAirTvState {
  final String message;

  const OnTheAirTvError(this.message);

  @override
  List<Object> get props => [message];
}

class OnTheAirTvLoaded extends OnTheAirTvState {
  final List<Tv> result;

  const OnTheAirTvLoaded(this.result);

  @override
  List<Object> get props => [result];
}
