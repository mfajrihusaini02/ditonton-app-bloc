import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/movie/get_watchlist_movies.dart';
import 'package:ditonton/domain/usecases/movie/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/movie/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/movie/save_watchlist.dart';
import 'package:ditonton/presentation/bloc/movie/watchlist_movie/watchlist_movie_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../provider/movie_detail_notifier_test.mocks.dart';
import '../provider/watchlist_movie_notifier_test.mocks.dart';

@GenerateMocks([
  WatchlistMovieBloc,
  GetWatchlistMovies,
  GetWatchListStatus,
  RemoveWatchlist,
  SaveWatchlist,
])
void main() {
  late MockGetWatchlistMovies mockGetWatchlistMovies;
  late MockGetWatchListStatus mockGetWatchListStatus;
  late MockSaveWatchlist mockSaveWatchlist;
  late MockRemoveWatchlist mockRemoveWatchlist;
  late WatchlistMovieBloc migrateMovieWatchlistBloc;

  setUp(() {
    mockGetWatchlistMovies = MockGetWatchlistMovies();
    mockGetWatchListStatus = MockGetWatchListStatus();
    mockSaveWatchlist = MockSaveWatchlist();
    mockRemoveWatchlist = MockRemoveWatchlist();
    migrateMovieWatchlistBloc = WatchlistMovieBloc(
      getWatchlistMovies: mockGetWatchlistMovies,
      getWatchListStatus: mockGetWatchListStatus,
      saveWatchlist: mockSaveWatchlist,
      removeWatchlist: mockRemoveWatchlist,
    );
  });

  const movieId = 1;

  test("initial state should be empty", () {
    expect(migrateMovieWatchlistBloc.state, WatchlistMovieEmpty());
  });

  blocTest<WatchlistMovieBloc, WatchlistMovieState>(
    'Should emit [Loading, Loaded] when data is gotten successfully',
    build: () {
      when(mockGetWatchlistMovies.execute()).thenAnswer(
        (_) async => Right(testWatchlistMovieList),
      );
      return migrateMovieWatchlistBloc;
    },
    act: (bloc) => bloc.add(FetchWatchlistMovieEvent()),
    expect: () => [
      WatchlistMovieLoading(),
      WatchlistMovieLoaded(testWatchlistMovieList),
    ],
    verify: (bloc) {
      verify(mockGetWatchlistMovies.execute());
    },
  );

  blocTest<WatchlistMovieBloc, WatchlistMovieState>(
    'Should emit [Loading, Error] when get watchlist is unsuccessful',
    build: () {
      when(mockGetWatchlistMovies.execute()).thenAnswer(
        (_) async => Left(ServerFailure("Can't get data")),
      );
      return migrateMovieWatchlistBloc;
    },
    act: (bloc) => bloc.add(FetchWatchlistMovieEvent()),
    expect: () => [
      WatchlistMovieLoading(),
      WatchlistMovieError("Can't get data"),
    ],
    verify: (bloc) {
      verify(mockGetWatchlistMovies.execute());
    },
  );

  blocTest<WatchlistMovieBloc, WatchlistMovieState>(
    'Should emit [Loaded] when get status movie watchlist is successful',
    build: () {
      when(mockGetWatchListStatus.execute(movieId)).thenAnswer(
        (_) async => true,
      );
      return migrateMovieWatchlistBloc;
    },
    act: (bloc) => bloc.add(FetchStatusMovieEvent(movieId)),
    expect: () => [WatchlistStatusMovieLoaded(true)],
    verify: (bloc) {
      verify(mockGetWatchListStatus.execute(movieId));
    },
  );

  blocTest<WatchlistMovieBloc, WatchlistMovieState>(
    'Should emit [success] when add movie item to watchlist is successful',
    build: () {
      when(mockSaveWatchlist.execute(testMovieDetail)).thenAnswer(
        (_) async => const Right("Success"),
      );
      return migrateMovieWatchlistBloc;
    },
    act: (bloc) => bloc.add(AddItemMovieEvent(testMovieDetail)),
    expect: () => [WatchlistMovieSuccess("Success")],
    verify: (bloc) {
      verify(mockSaveWatchlist.execute(testMovieDetail));
    },
  );

  blocTest<WatchlistMovieBloc, WatchlistMovieState>(
    'Should emit [success] when remove movie item to watchlist is successful',
    build: () {
      when(mockRemoveWatchlist.execute(testMovieDetail)).thenAnswer(
        (_) async => const Right("Removed"),
      );
      return migrateMovieWatchlistBloc;
    },
    act: (bloc) => bloc.add(RemoveItemMovieEvent(testMovieDetail)),
    expect: () => [WatchlistMovieSuccess("Removed")],
    verify: (bloc) {
      verify(mockRemoveWatchlist.execute(testMovieDetail));
    },
  );

  blocTest<WatchlistMovieBloc, WatchlistMovieState>(
    'Should emit [error] when add movie item to watchlist is unsuccessful',
    build: () {
      when(mockSaveWatchlist.execute(testMovieDetail)).thenAnswer(
        (_) async => Left(DatabaseFailure('Failed')),
      );
      return migrateMovieWatchlistBloc;
    },
    act: (bloc) => bloc.add(AddItemMovieEvent(testMovieDetail)),
    expect: () => [WatchlistMovieError("Failed")],
    verify: (bloc) {
      verify(mockSaveWatchlist.execute(testMovieDetail));
    },
  );

  blocTest<WatchlistMovieBloc, WatchlistMovieState>(
    'Should emit [error] when remove movie item to watchlist is unsuccessful',
    build: () {
      when(mockRemoveWatchlist.execute(testMovieDetail)).thenAnswer(
        (_) async => Left(DatabaseFailure('Failed')),
      );
      return migrateMovieWatchlistBloc;
    },
    act: (bloc) => bloc.add(RemoveItemMovieEvent(testMovieDetail)),
    expect: () => [WatchlistMovieError("Failed")],
    verify: (bloc) {
      verify(mockRemoveWatchlist.execute(testMovieDetail));
    },
  );
}
