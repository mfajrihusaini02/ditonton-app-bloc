import 'package:ditonton/data/models/tv/tv_model.dart';
import 'package:equatable/equatable.dart';

class TvResponse extends Equatable {
  final List<TvModel> tvList;

  TvResponse({required this.tvList});

  factory TvResponse.fromJson(Map<String, dynamic> json) {
    return TvResponse(
      tvList: List<TvModel>.from(
        (json["results"] as List)
            .map((x) => TvModel.fromJson(x))
            .where((e) => e.posterPath != null),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "results": List<dynamic>.from(tvList.map((x) => x.toJson())),
    };
  }

  @override
  List<Object> get props => [tvList];
}
