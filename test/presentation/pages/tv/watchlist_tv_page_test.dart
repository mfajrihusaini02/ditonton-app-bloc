import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/presentation/bloc/tv/watchlist_tv/watchlist_tv_bloc.dart';
import 'package:ditonton/presentation/pages/watchlist_tv_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mocktail/mocktail.dart';

import '../../../dummy_data/dummy_objects.dart';

class MockWatchlistTvBloc extends MockBloc<WatchlistTvEvent, WatchlistTvState>
    implements WatchlistTvBloc {}

class FakeWatchlistTvEvent extends Fake implements WatchlistTvEvent {}

class FakeWatchlistTvState extends Fake implements WatchlistTvState {}

@GenerateMocks([WatchlistTvBloc])
void main() {
  late MockWatchlistTvBloc mockWatchlistTvBloc;

  setUp(() {
    mockWatchlistTvBloc = MockWatchlistTvBloc();
  });

  setUpAll(() {
    registerFallbackValue(FakeWatchlistTvEvent());
    registerFallbackValue(FakeWatchlistTvState());
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<WatchlistTvBloc>.value(
      value: mockWatchlistTvBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Should display center progress bar when loading',
      (WidgetTester tester) async {
    when(() => mockWatchlistTvBloc.state).thenReturn(
      WatchlistTvLoading(),
    );

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(WatchlistTvPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Should display ListView when data is loaded',
      (WidgetTester tester) async {
    when(() => mockWatchlistTvBloc.state).thenReturn(
      WatchlistTvLoaded(testTvList),
    );

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(WatchlistTvPage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Should display text with message when Error',
      (WidgetTester tester) async {
    when(() => mockWatchlistTvBloc.state).thenReturn(
      WatchlistTvError('error_message'),
    );

    final textFinder = find.byKey(Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget(WatchlistTvPage()));

    expect(textFinder, findsOneWidget);
  });
}
