import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_detail.dart';
import 'package:ditonton/presentation/bloc/tv/detail_tv/detail_tv_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import '../../provider/tv/tv_detail_notifier_test.mocks.dart';

@GenerateMocks([DetailTvBloc, GetTvDetail])
void main() {
  late MockGetTvDetail mockGetTvDetail;
  late DetailTvBloc detailTvBloc;
  setUp(() {
    mockGetTvDetail = MockGetTvDetail();
    detailTvBloc = DetailTvBloc(mockGetTvDetail);
  });

  const tvId = 1;

  test("initial state should be empty", () {
    expect(detailTvBloc.state, DetailTvEmpty());
  });

  group('Detail Movies BLoC Test', () {
    blocTest<DetailTvBloc, DetailTvState>(
      'Should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        when(mockGetTvDetail.execute(tvId)).thenAnswer(
          (_) async => Right(testTvDetail),
        );
        return detailTvBloc;
      },
      act: (bloc) => bloc.add(const FetchDetailTvEvent(tvId)),
      expect: () => [
        DetailTvLoading(),
        DetailTvLoaded(testTvDetail),
      ],
      verify: (bloc) {
        verify(mockGetTvDetail.execute(tvId));
      },
    );

    blocTest<DetailTvBloc, DetailTvState>(
      'Should emit [Loading, Error] when get detail is unsuccessful',
      build: () {
        when(mockGetTvDetail.execute(tvId)).thenAnswer(
          (_) async => Left(ServerFailure('Server Failure')),
        );
        return detailTvBloc;
      },
      act: (bloc) => bloc.add(FetchDetailTvEvent(tvId)),
      expect: () => [DetailTvLoading(), DetailTvError('Server Failure')],
      verify: (bloc) {
        verify(mockGetTvDetail.execute(tvId));
      },
    );
  });
}
