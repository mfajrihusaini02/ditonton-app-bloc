import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv/tv.dart';
import 'package:ditonton/domain/usecases/tv/get_on_the_air_tv.dart';
import 'package:ditonton/presentation/bloc/tv/on_the_air_tv/on_the_air_tv_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'on_the_air_tv_bloc_test.mocks.dart';

@GenerateMocks([OnTheAirTvBloc, GetOnTheAirTv])
void main() {
  late MockGetOnTheAirTv mockGetOnTheAirTv;
  late OnTheAirTvBloc onTheAirTvBloc;

  setUp(() {
    mockGetOnTheAirTv = MockGetOnTheAirTv();
    onTheAirTvBloc = OnTheAirTvBloc(mockGetOnTheAirTv);
  });

  final tvList = <Tv>[];

  test("initial state should be empty", () {
    expect(onTheAirTvBloc.state, OnTheAirTvEmpty());
  });

  group('On Air TV BLoC Test', () {
    blocTest<OnTheAirTvBloc, OnTheAirTvState>(
      'Should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        when(mockGetOnTheAirTv.execute()).thenAnswer(
          (_) async => Right(tvList),
        );
        return onTheAirTvBloc;
      },
      act: (bloc) => bloc.add(FetchOnTheAirTvEvent()),
      expect: () => [
        OnTheAirTvLoading(),
        OnTheAirTvLoaded(tvList),
      ],
      verify: (bloc) {
        verify(mockGetOnTheAirTv.execute());
      },
    );

    blocTest<OnTheAirTvBloc, OnTheAirTvState>(
      'Should emit [Loading, Error] when get now playing is unsuccessful',
      build: () {
        when(mockGetOnTheAirTv.execute()).thenAnswer(
          (_) async => Left(ServerFailure('Server Failure')),
        );
        return onTheAirTvBloc;
      },
      act: (bloc) => bloc.add(FetchOnTheAirTvEvent()),
      expect: () => [
        OnTheAirTvLoading(),
        OnTheAirTvError('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockGetOnTheAirTv.execute());
      },
    );
  });
}
