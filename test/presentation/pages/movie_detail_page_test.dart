import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/presentation/bloc/movie/detail_movie/detail_movie_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/detail_movie/detail_movie_event.dart';
import 'package:ditonton/presentation/bloc/movie/detail_movie/detail_movie_state.dart';
import 'package:ditonton/presentation/bloc/movie/recommendation_movie/recommendation_movie_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/watchlist_movie/watchlist_movie_bloc.dart';
import 'package:ditonton/presentation/pages/detail_movie_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';

class MockDetailMovieBloc extends MockBloc<DetailMovieEvent, DetailMovieState>
    implements DetailMovieBloc {}

class DetailMovieEventFake extends Fake implements DetailMovieEvent {}

class DetailMovieStateFake extends Fake implements DetailMovieState {}

class MockRecommendMoviesBloc
    extends MockBloc<RecommendationMovieEvent, RecommendationMovieState>
    implements RecommendationMovieBloc {}

class RecommendationMoviesEventFake extends Fake
    implements RecommendationMovieEvent {}

class RecommendationMoviesStateFake extends Fake
    implements RecommendationMovieState {}

class MockWatchlistMoviesBloc
    extends MockBloc<WatchlistMovieEvent, WatchlistMovieState>
    implements WatchlistMovieBloc {}

class WatchlistMoviesEventFake extends Fake implements WatchlistMovieEvent {}

class WatchlistMoviesStateFake extends Fake implements WatchlistMovieState {}

@GenerateMocks([DetailMovieBloc])
void main() {
  late MockDetailMovieBloc mockDetailMovieBloc;
  late MockRecommendMoviesBloc mockRecommendationMoviesBloc;
  late MockWatchlistMoviesBloc mockWatchlistMoviesBloc;

  setUpAll(() {
    registerFallbackValue(DetailMovieEventFake());
    registerFallbackValue(DetailMovieStateFake());
    registerFallbackValue(RecommendationMoviesEventFake());
    registerFallbackValue(RecommendationMoviesStateFake());
    registerFallbackValue(WatchlistMoviesEventFake());
    registerFallbackValue(WatchlistMoviesStateFake());
  });

  setUp(() {
    mockDetailMovieBloc = MockDetailMovieBloc();
    mockRecommendationMoviesBloc = MockRecommendMoviesBloc();
    mockWatchlistMoviesBloc = MockWatchlistMoviesBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<DetailMovieBloc>(
          create: (context) => mockDetailMovieBloc,
        ),
        BlocProvider<RecommendationMovieBloc>(
          create: (context) => mockRecommendationMoviesBloc,
        ),
        BlocProvider<WatchlistMovieBloc>(
          create: (context) => mockWatchlistMoviesBloc,
        ),
      ],
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets(
      'Watchlist button should display add icon when Movie not added to watchlist',
      (WidgetTester tester) async {
    when(() => mockDetailMovieBloc.state).thenReturn(
      DetailMovieLoaded(testMovieDetail),
    );
    when(() => mockRecommendationMoviesBloc.state).thenReturn(
      RecommendationMovieLoaded(testMovieList),
    );
    when(() => mockWatchlistMoviesBloc.state).thenReturn(
      WatchlistStatusMovieLoaded(false),
    );

    final watchlistButtonIcon = find.byIcon(Icons.add);

    await tester.pumpWidget(_makeTestableWidget(DetailMoviePage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should dispay check icon when Movie is added to wathclist',
      (WidgetTester tester) async {
    when(() => mockDetailMovieBloc.state).thenReturn(
      DetailMovieLoaded(testMovieDetail),
    );
    when(() => mockRecommendationMoviesBloc.state).thenReturn(
      RecommendationMovieLoaded(testMovieList),
    );
    when(() => mockWatchlistMoviesBloc.state).thenReturn(
      WatchlistStatusMovieLoaded(true),
    );

    final watchlistButtonIcon = find.byIcon(Icons.check);

    await tester.pumpWidget(_makeTestableWidget(DetailMoviePage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });
}
