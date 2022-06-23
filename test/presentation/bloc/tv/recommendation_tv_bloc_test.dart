import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv/tv.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_recommendations.dart';
import 'package:ditonton/presentation/bloc/tv/recommendation_tv/recommendation_tv_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'recommendation_tv_bloc_test.mocks.dart';

@GenerateMocks([RecommendationTvBloc, GetTvRecommendations])
void main() {
  late MockGetTvRecommendations mockGetTvRecommendations;
  late RecommendationTvBloc migrateTvlsRecommendationBloc;

  setUp(() {
    mockGetTvRecommendations = MockGetTvRecommendations();
    migrateTvlsRecommendationBloc =
        RecommendationTvBloc(mockGetTvRecommendations);
  });

  test("initial state should be empty", () {
    expect(migrateTvlsRecommendationBloc.state, RecommendationTvEmpty());
  });

  const tvId = 1;
  final tvList = <Tv>[];

  blocTest<RecommendationTvBloc, RecommendationTvState>(
    'Should emit [Loading, Loaded] when data is gotten successfully',
    build: () {
      when(mockGetTvRecommendations.execute(tvId)).thenAnswer(
        (_) async => Right(tvList),
      );
      return migrateTvlsRecommendationBloc;
    },
    act: (bloc) => bloc.add(FetchRecommendationTvEvent(tvId)),
    expect: () => [
      RecommendationTvLoading(),
      RecommendationTvLoaded(tvList),
    ],
    verify: (bloc) {
      verify(mockGetTvRecommendations.execute(tvId));
    },
  );

  group('Recommendation TV BLoC Test', () {
    blocTest<RecommendationTvBloc, RecommendationTvState>(
      'Should emit [Loading, Error] when get recommendation is unsuccessful',
      build: () {
        when(mockGetTvRecommendations.execute(tvId)).thenAnswer(
          (_) async => Left(ServerFailure('Server Failure')),
        );
        return migrateTvlsRecommendationBloc;
      },
      act: (bloc) => bloc.add(FetchRecommendationTvEvent(tvId)),
      expect: () => [
        RecommendationTvLoading(),
        RecommendationTvError('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockGetTvRecommendations.execute(tvId));
      },
    );
  });
}
