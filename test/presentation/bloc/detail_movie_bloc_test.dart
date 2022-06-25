import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/movie/get_movie_detail.dart';
import 'package:ditonton/presentation/bloc/movie/detail_movie/detail_movie_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/detail_movie/detail_movie_event.dart';
import 'package:ditonton/presentation/bloc/movie/detail_movie/detail_movie_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'detail_movie_bloc_test.mocks.dart';

@GenerateMocks([DetailMovieBloc, GetMovieDetail])
void main() {
  late MockGetMovieDetail mockGetMovieDetail;
  late DetailMovieBloc detailMovieBloc;

  setUp(() {
    mockGetMovieDetail = MockGetMovieDetail();
    detailMovieBloc =
        DetailMovieBloc(mockGetMovieDetail);
  });

  const movieId = 1;

  test("initial state should be empty", () {
    expect(detailMovieBloc.state, DetailMovieEmpty());
  });

  group('Detail Movies BLoC Test', () {
    blocTest<DetailMovieBloc, DetailMovieState>(
      'Should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        when(mockGetMovieDetail.execute(movieId)).thenAnswer(
          (_) async => Right(testMovieDetail),
        );
        return detailMovieBloc;
      },
      act: (bloc) => bloc.add(FetchDetailMovieEvent(movieId)),
      expect: () => [
        DetailMovieLoading(),
        DetailMovieLoaded(testMovieDetail),
      ],
      verify: (bloc) {
        verify(mockGetMovieDetail.execute(movieId));
      },
    );

    blocTest<DetailMovieBloc, DetailMovieState>(
      'Should emit [Loading, Error] when get detail is unsuccessful',
      build: () {
        when(mockGetMovieDetail.execute(movieId)).thenAnswer(
          (_) async => Left(ServerFailure('Server Failure')),
        );
        return detailMovieBloc;
      },
      act: (bloc) => bloc.add(FetchDetailMovieEvent(movieId)),
      expect: () => [
        DetailMovieLoading(),
        const DetailMovieError('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockGetMovieDetail.execute(movieId));
      },
    );
  });
}
