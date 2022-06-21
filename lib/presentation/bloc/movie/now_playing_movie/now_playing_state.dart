part of 'now_playing_bloc.dart';

abstract class NowPlayingState extends Equatable {
  const NowPlayingState();
  
  @override
  List<Object> get props => [];
}

class NowPlayingInitial extends NowPlayingState {}
