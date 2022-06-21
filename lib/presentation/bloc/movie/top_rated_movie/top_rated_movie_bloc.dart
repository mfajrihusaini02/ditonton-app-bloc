import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'top_rated_movie_event.dart';
part 'top_rated_movie_state.dart';

class TopRatedMovieBloc extends Bloc<TopRatedMovieEvent, TopRatedMovieState> {
  TopRatedMovieBloc() : super(TopRatedMovieInitial()) {
    on<TopRatedMovieEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
