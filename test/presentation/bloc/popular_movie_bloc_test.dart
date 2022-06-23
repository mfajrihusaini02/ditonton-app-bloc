import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie/movie.dart';
import 'package:ditonton/domain/usecases/movie/get_popular_movies.dart';
import 'package:ditonton/presentation/bloc/movie/popular_movie/popular_movie_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../provider/popular_movies_notifier_test.mocks.dart';

@GenerateMocks([PopularMovieBloc, GetPopularMovies])
void main() {
  late MockGetPopularMovies mockGetPopularMovies;
  late PopularMovieBloc popularMovieBloc;

  setUp(() {
    mockGetPopularMovies = MockGetPopularMovies();
    popularMovieBloc = PopularMovieBloc(mockGetPopularMovies);
  });

  final movieList = <Movie>[];

  test("initial state should be empty", () {
    expect(popularMovieBloc.state, PopularMovieEmpty());
  });

  group('Popular Movies BLoC Test', () {
    blocTest<PopularMovieBloc, PopularMovieState>(
      'Should emit [loading, loaded] when data is loaded successfully',
      build: () {
        when(mockGetPopularMovies.execute()).thenAnswer(
          (_) async => Right(movieList),
        );
        return popularMovieBloc;
      },
      act: (bloc) => bloc.add(FetchPopularMovieEvent()),
      expect: () => [
        PopularMovieLoading(),
        PopularMovieLoaded(movieList),
      ],
      verify: (bloc) {
        verify(mockGetPopularMovies.execute());
      },
    );

    blocTest<PopularMovieBloc, PopularMovieState>(
      'Should emit [loading, error] when data is failed to loaded',
      build: () {
        when(mockGetPopularMovies.execute()).thenAnswer(
          (_) async => Left(
            ServerFailure('Server Failure'),
          ),
        );
        return popularMovieBloc;
      },
      act: (bloc) => bloc.add(FetchPopularMovieEvent()),
      expect: () => [
        PopularMovieLoading(),
        PopularMovieError('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockGetPopularMovies.execute());
      },
    );
  });
}
