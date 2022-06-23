import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/tv/tv.dart';
import 'package:ditonton/domain/usecases/tv/get_on_the_air_tv.dart';
import 'package:equatable/equatable.dart';

part 'on_the_air_tv_event.dart';
part 'on_the_air_tv_state.dart';

class OnTheAirTvBloc extends Bloc<OnTheAirTvEvent, OnTheAirTvState> {
  final GetOnTheAirTv getOnTheAirTv;

  OnTheAirTvBloc(this.getOnTheAirTv) : super(OnTheAirTvEmpty()) {
    on<FetchOnTheAirTvEvent>((event, emit) async {
      emit(OnTheAirTvLoading());
      final result = await getOnTheAirTv.execute();
      result.fold(
        (failure) {
          emit(OnTheAirTvError(failure.message));
        },
        (data) {
          emit(OnTheAirTvLoaded(data));
        },
      );
    });
  }
}
