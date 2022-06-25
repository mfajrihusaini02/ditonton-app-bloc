import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/presentation/bloc/tv/detail_tv/detail_tv_bloc.dart';
import 'package:ditonton/presentation/bloc/tv/recommendation_tv/recommendation_tv_bloc.dart';
import 'package:ditonton/presentation/bloc/tv/watchlist_tv/watchlist_tv_bloc.dart';
import 'package:ditonton/presentation/pages/detail_tv_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mocktail/mocktail.dart';

import '../../../dummy_data/dummy_objects.dart';

class MockDetailTvBloc extends MockBloc<DetailTvEvent, DetailTvState>
    implements DetailTvBloc {}

class DetailTvEventFake extends Fake implements DetailTvEvent {}

class DetailTvStateFake extends Fake implements DetailTvState {}

class MockRecommendTvsBloc
    extends MockBloc<RecommendationTvEvent, RecommendationTvState>
    implements RecommendationTvBloc {}

class RecommendationTvsEventFake extends Fake implements RecommendationTvEvent {
}

class RecommendationTvsStateFake extends Fake implements RecommendationTvState {
}

class MockWatchlistTvsBloc extends MockBloc<WatchlistTvEvent, WatchlistTvState>
    implements WatchlistTvBloc {}

class WatchlistTvsEventFake extends Fake implements WatchlistTvEvent {}

class WatchlistTvsStateFake extends Fake implements WatchlistTvState {}

@GenerateMocks([DetailTvBloc])
void main() {
  late MockDetailTvBloc mockDetailTvBloc;
  late MockRecommendTvsBloc mockRecommendationTvsBloc;
  late MockWatchlistTvsBloc mockWatchlistTvsBloc;

  setUpAll(() {
    registerFallbackValue(DetailTvEventFake());
    registerFallbackValue(DetailTvStateFake());
    registerFallbackValue(RecommendationTvsEventFake());
    registerFallbackValue(RecommendationTvsStateFake());
    registerFallbackValue(WatchlistTvsEventFake());
    registerFallbackValue(WatchlistTvsStateFake());
  });

  setUp(() {
    mockDetailTvBloc = MockDetailTvBloc();
    mockRecommendationTvsBloc = MockRecommendTvsBloc();
    mockWatchlistTvsBloc = MockWatchlistTvsBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<DetailTvBloc>(
          create: (context) => mockDetailTvBloc,
        ),
        BlocProvider<RecommendationTvBloc>(
          create: (context) => mockRecommendationTvsBloc,
        ),
        BlocProvider<WatchlistTvBloc>(
          create: (context) => mockWatchlistTvsBloc,
        ),
      ],
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets(
      'Watchlist button should display add icon when Tv not added to watchlist',
      (WidgetTester tester) async {
    when(() => mockDetailTvBloc.state).thenReturn(
      DetailTvLoaded(testTvDetail),
    );
    when(() => mockRecommendationTvsBloc.state).thenReturn(
      RecommendationTvLoaded(testTvList),
    );
    when(() => mockWatchlistTvsBloc.state).thenReturn(
      WatchlistTvStatusLoaded(false),
    );

    final watchlistButtonIcon = find.byIcon(Icons.add);

    await tester.pumpWidget(_makeTestableWidget(DetailTvPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should dispay check icon when Tv is added to wathclist',
      (WidgetTester tester) async {
    when(() => mockDetailTvBloc.state).thenReturn(
      DetailTvLoaded(testTvDetail),
    );
    when(() => mockRecommendationTvsBloc.state).thenReturn(
      RecommendationTvLoaded(testTvList),
    );
    when(() => mockWatchlistTvsBloc.state).thenReturn(
      WatchlistTvStatusLoaded(true),
    );

    final watchlistButtonIcon = find.byIcon(Icons.check);

    await tester.pumpWidget(_makeTestableWidget(DetailTvPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });
}
