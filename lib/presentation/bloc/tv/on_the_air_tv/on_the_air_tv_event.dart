part of 'on_the_air_tv_bloc.dart';

abstract class OnTheAirTvEvent extends Equatable {
  const OnTheAirTvEvent();

  @override
  List<Object> get props => [];
}

class FetchOnTheAirTvEvent extends OnTheAirTvEvent {}
