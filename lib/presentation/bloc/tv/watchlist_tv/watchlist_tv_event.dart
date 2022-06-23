part of 'watchlist_tv_bloc.dart';

abstract class WatchlistTvEvent extends Equatable {
  const WatchlistTvEvent();

  @override
  List<Object> get props => [];
}

class FetchWatchlistTvEvent extends WatchlistTvEvent {}

class FetchStatusEvent extends WatchlistTvEvent {
  final int id;

  const FetchStatusEvent(this.id);

  @override
  List<Object> get props => [id];
}

class FetchStatusTvEvent extends WatchlistTvEvent {
  final int id;

  const FetchStatusTvEvent(this.id);

  @override
  List<Object> get props => [id];
}

class AddItemTvEvent extends WatchlistTvEvent {
  final TvDetail result;

  const AddItemTvEvent(this.result);

  @override
  List<Object> get props => [result];
}

class RemoveItemTvEvent extends WatchlistTvEvent {
  final TvDetail result;

  const RemoveItemTvEvent(this.result);

  @override
  List<Object> get props => [result];
}
