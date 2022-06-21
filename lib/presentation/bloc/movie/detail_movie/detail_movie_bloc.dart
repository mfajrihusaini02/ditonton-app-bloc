import 'package:ditonton/domain/usecases/movie/get_movie_detail.dart';
import 'package:ditonton/presentation/bloc/movie/detail_movie/detail_movie_event.dart';
import 'package:ditonton/presentation/bloc/movie/detail_movie/detail_movie_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetailMovieBloc extends Bloc<DetailMovieEvent, DetailMovieState> {
  final GetMovieDetail getMovieDetail;

  DetailMovieBloc({required this.getMovieDetail}) : super(DetailMovieEmpty()) {
    on<FetchDetailMovieEvent>((event, emit) async {
      emit(DetailMovieLoading());
      final result = await getMovieDetail.execute(event.id);

      result.fold((failure) {
        emit(DetailMovieError(failure.message));
      }, (e) {
        emit(DetailMovieLoaded(e));
      });
    });
  }
}
