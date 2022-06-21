import 'package:ditonton/domain/repositories/tv_repository.dart';

class GetWatchListStatusTv {
  final TvRepository tvRepository;

  GetWatchListStatusTv(this.tvRepository);

  Future<bool> execute(int id) async {
    return tvRepository.isAddedToWatchlistTv(id);
  }
}
