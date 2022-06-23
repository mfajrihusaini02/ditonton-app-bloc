import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv/tv.dart';
import 'package:ditonton/domain/usecases/tv/get_popular_tv.dart';
import 'package:ditonton/presentation/bloc/tv/popular_tv/popular_tv_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'popular_tv_bloc_test.mocks.dart';

@GenerateMocks([PopularTvBloc, GetPopularTv])
void main() {
  late MockGetPopularTv mockGetPopularTv;
  late PopularTvBloc popularTvBloc;

  setUp(() {
    mockGetPopularTv = MockGetPopularTv();
    popularTvBloc = PopularTvBloc(mockGetPopularTv);
  });

  final TvList = <Tv>[];

  test("initial state should be empty", () {
    expect(popularTvBloc.state, PopularTvEmpty());
  });

  group('Popular TV BLoC Test', () {
    blocTest<PopularTvBloc, PopularTvState>(
      'Should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        when(mockGetPopularTv.execute()).thenAnswer(
          (_) async => Right(TvList),
        );
        return popularTvBloc;
      },
      act: (bloc) => bloc.add(FetchPopularTvEvent()),
      expect: () => [
        PopularTvLoading(),
        PopularTvLoaded(TvList),
      ],
      verify: (bloc) {
        verify(mockGetPopularTv.execute());
      },
    );

    blocTest<PopularTvBloc, PopularTvState>(
      'Should emit [Loading, Error] when get popular is unsuccessful',
      build: () {
        when(mockGetPopularTv.execute()).thenAnswer(
          (_) async => Left(ServerFailure('Server Failure')),
        );
        return popularTvBloc;
      },
      act: (bloc) => bloc.add(FetchPopularTvEvent()),
      expect: () => [PopularTvLoading(), PopularTvError('Server Failure')],
      verify: (bloc) {
        verify(mockGetPopularTv.execute());
      },
    );
  });
}
