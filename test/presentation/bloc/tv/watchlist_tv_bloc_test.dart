import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/tv/get_watchlist_status_tv.dart';
import 'package:ditonton/domain/usecases/tv/get_watchlist_tv.dart';
import 'package:ditonton/domain/usecases/tv/remove_watchlist_tv.dart';
import 'package:ditonton/domain/usecases/tv/save_watchlist_tv.dart';
import 'package:ditonton/presentation/bloc/tv/watchlist_tv/watchlist_tv_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'watchlist_tv_bloc_test.mocks.dart';

@GenerateMocks([
  WatchlistTvBloc,
  GetWatchlistTv,
  GetWatchListStatusTv,
  RemoveWatchlistTv,
  SaveWatchlistTv,
])
void main() {
  late MockGetWatchlistTv mockGetWatchlistTv;
  late MockGetWatchListStatusTv mockGetWatchListStatusTv;
  late MockSaveWatchlistTv mockSaveWatchlistTv;
  late MockRemoveWatchlistTv mockRemoveWatchlistTv;
  late WatchlistTvBloc watchlistTvBloc;

  setUp(() {
    mockGetWatchlistTv = MockGetWatchlistTv();
    mockGetWatchListStatusTv = MockGetWatchListStatusTv();
    mockSaveWatchlistTv = MockSaveWatchlistTv();
    mockRemoveWatchlistTv = MockRemoveWatchlistTv();
    watchlistTvBloc = WatchlistTvBloc(
      getWatchlistTv: mockGetWatchlistTv,
      getWatchListStatus: mockGetWatchListStatusTv,
      saveWatchlist: mockSaveWatchlistTv,
      removeWatchlist: mockRemoveWatchlistTv,
    );
  });

  const tvId = 1;

  test("initial state should be empty", () {
    expect(watchlistTvBloc.state, WatchlistTvEmpty());
  });

  blocTest<WatchlistTvBloc, WatchlistTvState>(
    'Should emit [Loading, Loaded] when data is gotten successfully',
    build: () {
      when(mockGetWatchlistTv.execute()).thenAnswer(
        (_) async => Right(testWatchlistTvList),
      );
      return watchlistTvBloc;
    },
    act: (bloc) => bloc.add(FetchWatchlistTvEvent()),
    expect: () =>
        [WatchlistTvLoading(), WatchlistTvLoaded(testWatchlistTvList)],
    verify: (bloc) {
      verify(mockGetWatchlistTv.execute());
    },
  );

  blocTest<WatchlistTvBloc, WatchlistTvState>(
    'Should emit [Loading, Error] when get watchlist is unsuccessful',
    build: () {
      when(mockGetWatchlistTv.execute()).thenAnswer(
        (_) async => Left(ServerFailure("Can't get data")),
      );
      return watchlistTvBloc;
    },
    act: (bloc) => bloc.add(FetchWatchlistTvEvent()),
    expect: () => [
      WatchlistTvLoading(),
      WatchlistTvError("Can't get data"),
    ],
    verify: (bloc) {
      verify(mockGetWatchlistTv.execute());
    },
  );

  blocTest<WatchlistTvBloc, WatchlistTvState>(
    'Should emit [Loaded] when get status TV watchlist is successful',
    build: () {
      when(mockGetWatchListStatusTv.execute(tvId)).thenAnswer(
        (_) async => true,
      );
      return watchlistTvBloc;
    },
    act: (bloc) => bloc.add(FetchStatusTvEvent(tvId)),
    expect: () => [WatchlistTvStatusLoaded(true)],
    verify: (bloc) {
      verify(mockGetWatchListStatusTv.execute(tvId));
    },
  );

  blocTest<WatchlistTvBloc, WatchlistTvState>(
    'Should emit [success] when add TV item to watchlist is successful',
    build: () {
      when(mockSaveWatchlistTv.execute(testTvDetail))
          .thenAnswer((_) async => const Right("Success"));
      return watchlistTvBloc;
    },
    act: (bloc) => bloc.add(AddItemTvEvent(testTvDetail)),
    expect: () => [const WatchlistTvSuccess("Success")],
    verify: (bloc) {
      verify(mockSaveWatchlistTv.execute(testTvDetail));
    },
  );

  blocTest<WatchlistTvBloc, WatchlistTvState>(
    'Should emit [success] when remove TV item to watchlist is successful',
    build: () {
      when(mockRemoveWatchlistTv.execute(testTvDetail)).thenAnswer(
        (_) async => const Right("Removed"),
      );
      return watchlistTvBloc;
    },
    act: (bloc) => bloc.add(RemoveItemTvEvent(testTvDetail)),
    expect: () => [WatchlistTvSuccess("Removed")],
    verify: (bloc) {
      verify(mockRemoveWatchlistTv.execute(testTvDetail));
    },
  );

  blocTest<WatchlistTvBloc, WatchlistTvState>(
    'Should emit [error] when add tv item to watchlist is unsuccessful',
    build: () {
      when(mockSaveWatchlistTv.execute(testTvDetail)).thenAnswer(
        (_) async => Left(DatabaseFailure('Failed')),
      );
      return watchlistTvBloc;
    },
    act: (bloc) => bloc.add(AddItemTvEvent(testTvDetail)),
    expect: () => [WatchlistTvError("Failed")],
    verify: (bloc) {
      verify(mockSaveWatchlistTv.execute(testTvDetail));
    },
  );

  blocTest<WatchlistTvBloc, WatchlistTvState>(
    'Should emit [error] when remove TV item to watchlist is unsuccessful',
    build: () {
      when(mockRemoveWatchlistTv.execute(testTvDetail)).thenAnswer(
        (_) async => Left(DatabaseFailure('Failed')),
      );
      return watchlistTvBloc;
    },
    act: (bloc) => bloc.add(RemoveItemTvEvent(testTvDetail)),
    expect: () => [const WatchlistTvError("Failed")],
    verify: (bloc) {
      verify(mockRemoveWatchlistTv.execute(testTvDetail));
    },
  );
}
