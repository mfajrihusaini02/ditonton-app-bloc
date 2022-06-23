import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/tv/tv.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_recommendations.dart';
import 'package:equatable/equatable.dart';

part 'recommendation_tv_event.dart';
part 'recommendation_tv_state.dart';

class RecommendationTvBloc
    extends Bloc<RecommendationTvEvent, RecommendationTvState> {
  final GetTvRecommendations getTvRecommendations;

  RecommendationTvBloc(this.getTvRecommendations)
      : super(RecommendationTvEmpty()) {
    on<FetchRecommendationTvEvent>((event, emit) async {
      emit(RecommendationTvLoading());
      final result = await getTvRecommendations.execute(event.id);
      result.fold(
        (failure) {
          emit(RecommendationTvError(failure.message));
        },
        (data) {
          emit(RecommendationTvLoaded(data));
        },
      );
    });
  }
}
