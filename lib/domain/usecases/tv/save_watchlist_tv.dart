import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv/tv_detail.dart';
import 'package:ditonton/domain/repositories/tv_repository.dart';

class SaveWatchlistTv {
  final TvRepository tvRepository;

  SaveWatchlistTv(this.tvRepository);

  Future<Either<Failure, String>> execute(TvDetail tv) {
    return tvRepository.saveWatchlistTv(tv);
  }
}