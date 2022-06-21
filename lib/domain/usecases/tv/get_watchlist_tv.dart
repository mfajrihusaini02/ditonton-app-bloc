import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv/tv.dart';
import 'package:ditonton/domain/repositories/tv_repository.dart';

class GetWatchlistTv {
  final TvRepository _tvRepository;

  GetWatchlistTv(this._tvRepository);

  Future<Either<Failure, List<Tv>>> execute() {
    return _tvRepository.getWatchlistTv();
  }
}