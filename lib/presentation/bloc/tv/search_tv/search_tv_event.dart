part of 'search_tv_bloc.dart';

abstract class SearchTvEvent extends Equatable {
  const SearchTvEvent();

  @override
  List<Object> get props => [];
}

class SearchTvSetEmpty extends SearchTvEvent {}

class OnQueryChangedTv extends SearchTvEvent {
  final String query;

  const OnQueryChangedTv(this.query);

  @override
  List<Object> get props => [query];
}
