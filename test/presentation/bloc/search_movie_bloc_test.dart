import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie/movie.dart';
import 'package:ditonton/domain/usecases/movie/search_movies.dart';
import 'package:ditonton/presentation/bloc/movie/search_movie/search_movie_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'search_movie_bloc_test.mocks.dart';

@GenerateMocks([SearchMovies])
void main() {
  late MockSearchMovies mockSearchMovies;
  late SearchMovieBloc searchMovieBloc;

  setUp(() {
    mockSearchMovies = MockSearchMovies();
    searchMovieBloc = SearchMovieBloc(mockSearchMovies);
  });

  const query = "originalTitle";
  final movieList = <Movie>[];

  test("initial state should be empty", () {
    expect(searchMovieBloc.state, SearchMovieEmpty());
  });

  blocTest<SearchMovieBloc, SearchMovieState>(
    'Should emit [Loading, Loaded] when data is gotten successfully',
    build: () {
      when(mockSearchMovies.execute(query)).thenAnswer(
        (_) async => Right(movieList),
      );
      return searchMovieBloc;
    },
    act: (bloc) => bloc.add(OnQueryChangedMovie(query)),
    expect: () => [
      SearchMovieLoading(),
      SearchMovieLoaded(movieList),
    ],
    verify: (bloc) {
      verify(mockSearchMovies.execute(query));
    },
  );

  group('Search Movies BLoC Test', () {
    blocTest<SearchMovieBloc, SearchMovieState>(
      'Should emit [Loading, Error] when get search is unsuccessful',
      build: () {
        when(mockSearchMovies.execute(query)).thenAnswer(
          (_) async => Left(ServerFailure('Server Failure')),
        );
        return searchMovieBloc;
      },
      act: (bloc) => bloc.add(OnQueryChangedMovie(query)),
      expect: () => [
        SearchMovieLoading(),
        SearchMovieError('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockSearchMovies.execute(query));
      },
    );
  });
}
