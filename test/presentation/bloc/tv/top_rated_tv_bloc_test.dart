import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv/tv.dart';
import 'package:ditonton/domain/usecases/tv/get_top_rated_tv.dart';
import 'package:ditonton/presentation/bloc/tv/top_rated_tv/top_rated_tv_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'top_rated_tv_bloc_test.mocks.dart';

@GenerateMocks([TopRatedTvBloc, GetTopRatedTv])
void main() {
  late MockGetTopRatedTv mockGetTopRatedTv;
  late TopRatedTvBloc topRatedTvBloc;

  setUp(() {
    mockGetTopRatedTv = MockGetTopRatedTv();
    topRatedTvBloc = TopRatedTvBloc(mockGetTopRatedTv);
  });

  final tvList = <Tv>[];

  test("initial state should be empty", () {
    expect(topRatedTvBloc.state, TopRatedTvEmpty());
  });

  group('Top Rated TV BLoC Test', () {
    blocTest<TopRatedTvBloc, TopRatedTvState>(
      'Should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        when(mockGetTopRatedTv.execute()).thenAnswer(
          (_) async => Right(tvList),
        );
        return topRatedTvBloc;
      },
      act: (bloc) => bloc.add(FetchTopRatedTvEvent()),
      expect: () => [
        TopRatedTvLoading(),
        TopRatedTvLoaded(tvList),
      ],
      verify: (bloc) {
        verify(mockGetTopRatedTv.execute());
      },
    );

    blocTest<TopRatedTvBloc, TopRatedTvState>(
      'Should emit [Loading, Error] when get top rated is unsuccessful',
      build: () {
        when(mockGetTopRatedTv.execute()).thenAnswer(
          (_) async => Left(ServerFailure('Server Failure')),
        );
        return topRatedTvBloc;
      },
      act: (bloc) => bloc.add(FetchTopRatedTvEvent()),
      expect: () => [
        TopRatedTvLoading(),
        TopRatedTvError('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockGetTopRatedTv.execute());
      },
    );
  });
}
