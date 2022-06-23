import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv/tv.dart';
import 'package:ditonton/domain/usecases/tv/search_tv.dart';
import 'package:ditonton/presentation/bloc/tv/search_tv/search_tv_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'search_tv_bloc_test.mocks.dart';

@GenerateMocks([SearchTvBloc, SearchTv])
void main() {
  late MockSearchTv mockSearchTv;
  late SearchTvBloc searchTvBloc;

  setUp(() {
    mockSearchTv = MockSearchTv();
    searchTvBloc = SearchTvBloc(mockSearchTv);
  });

  const query = "originalTitle";
  final tvList = <Tv>[];

  test("initial state should be empty", () {
    expect(searchTvBloc.state, SearchTvEmpty());
  });

  blocTest<SearchTvBloc, SearchTvState>(
    'Should emit [Loading, Loaded] when data is gotten successfully',
    build: () {
      when(mockSearchTv.execute(query)).thenAnswer(
        (_) async => Right(tvList),
      );
      return searchTvBloc;
    },
    act: (bloc) => bloc.add(OnQueryChangedTv(query)),
    expect: () => [
      SearchTvLoading(),
      SearchTvLoaded(tvList),
    ],
    verify: (bloc) {
      verify(mockSearchTv.execute(query));
    },
  );

  group('Search TV BLoC Test', () {
    blocTest<SearchTvBloc, SearchTvState>(
      'Should emit [Loading, Error] when get search is unsuccessful',
      build: () {
        when(mockSearchTv.execute(query)).thenAnswer(
          (_) async => Left(ServerFailure('Server Failure')),
        );
        return searchTvBloc;
      },
      act: (bloc) => bloc.add(OnQueryChangedTv(query)),
      expect: () => [
        SearchTvLoading(),
        SearchTvError('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockSearchTv.execute(query));
      },
    );
  });
}
