import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/tv/tv.dart';
import 'package:ditonton/domain/entities/tv/tv_detail.dart';
import 'package:ditonton/presentation/bloc/tv/detail_tv/detail_tv_bloc.dart';
import 'package:ditonton/presentation/bloc/tv/recommendation_tv/recommendation_tv_bloc.dart';
import 'package:ditonton/presentation/bloc/tv/watchlist_tv/watchlist_tv_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class DetailTvPage extends StatefulWidget {
  static const ROUTE_NAME = '/detail_tv';

  final int id;
  DetailTvPage({required this.id});

  @override
  _DetailTvPageState createState() => _DetailTvPageState();
}

class _DetailTvPageState extends State<DetailTvPage> {
  @override
  void initState() {
    super.initState();
    context.read<DetailTvBloc>().add(FetchDetailTvEvent(widget.id));
    context.read<WatchlistTvBloc>().add(FetchStatusTvEvent(widget.id));
    context
        .read<RecommendationTvBloc>()
        .add(FetchRecommendationTvEvent(widget.id));
  }

  @override
  Widget build(BuildContext context) {
    RecommendationTvState tvlsRecommendations =
        context.watch<RecommendationTvBloc>().state;

    return Scaffold(
      body: BlocListener<WatchlistTvBloc, WatchlistTvState>(
        listener: (_, state) {
          if (state is WatchlistTvSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.message),
            ));
            context.read<WatchlistTvBloc>().add(FetchStatusTvEvent(widget.id));
          }
        },
        child: BlocBuilder<DetailTvBloc, DetailTvState>(
          builder: (context, state) {
            if (state is DetailTvLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is DetailTvLoaded) {
              final tv = state.result;
              bool isAddedToWatchlistTv = (context
                      .watch<WatchlistTvBloc>()
                      .state is WatchlistTvStatusLoaded)
                  ? (context.read<WatchlistTvBloc>().state
                          as WatchlistTvStatusLoaded)
                      .result
                  : false;
              return SafeArea(
                child: DetailContent(
                  tv,
                  tvlsRecommendations is RecommendationTvLoaded
                      ? tvlsRecommendations.result
                      : List.empty(),
                  isAddedToWatchlistTv,
                ),
              );
            } else {
              return Text("Empty");
            }
          },
        ),
      ),
    );
  }
}

class DetailContent extends StatelessWidget {
  final TvDetail tv;
  final List<Tv> recommendations;
  final bool isAddedWatchlist;

  DetailContent(this.tv, this.recommendations, this.isAddedWatchlist);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: 'https://image.tmdb.org/t/p/w500${tv.posterPath}',
          width: screenWidth,
          placeholder: (context, url) => Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: kRichBlack,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                padding: const EdgeInsets.only(
                  left: 16,
                  top: 16,
                  right: 16,
                ),
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tv.name,
                              style: kHeading5,
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                if (!isAddedWatchlist) {
                                  BlocProvider.of<WatchlistTvBloc>(context)
                                    ..add(AddItemTvEvent(tv));
                                } else {
                                  BlocProvider.of<WatchlistTvBloc>(context)
                                    ..add(RemoveItemTvEvent(tv));
                                }
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  isAddedWatchlist
                                      ? Icon(Icons.check)
                                      : Icon(Icons.add),
                                  Text('Watchlist'),
                                ],
                              ),
                            ),
                            Text(
                              _showGenres(tv.genres),
                            ),
                            Text(tv.firstAirDate),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: tv.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${tv.voteAverage}')
                              ],
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Overview',
                              style: kHeading6,
                            ),
                            Text(
                              tv.overview,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Recommendations',
                              style: kHeading6,
                            ),
                            BlocBuilder<RecommendationTvBloc,
                                RecommendationTvState>(
                              builder: (context, state) {
                                if (state is RecommendationTvLoading) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (state is RecommendationTvError) {
                                  return Text(state.message);
                                } else if (state is RecommendationTvLoaded) {
                                  final recommendations = state.result;
                                  if (recommendations.isEmpty) {
                                    return const Text(
                                      "Tidak ada tv recommendations",
                                    );
                                  }
                                  return Container(
                                    height: 150,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        final tv = recommendations[index];
                                        return Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.pushReplacementNamed(
                                                context,
                                                DetailTvPage.ROUTE_NAME,
                                                arguments: tv.id,
                                              );
                                            },
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(8),
                                              ),
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    'https://image.tmdb.org/t/p/w500${tv.posterPath}',
                                                placeholder: (context, url) =>
                                                    Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Icon(Icons.error),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      itemCount: recommendations.length,
                                    ),
                                  );
                                } else {
                                  return Container();
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        color: Colors.white,
                        height: 4,
                        width: 48,
                      ),
                    ),
                  ],
                ),
              );
            },
            // initialChildSize: 0.5,
            minChildSize: 0.25,
            // maxChildSize: 1.0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: kRichBlack,
            foregroundColor: Colors.white,
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        )
      ],
    );
  }

  String _showGenres(List<Genre> genres) {
    String result = '';
    for (var genre in genres) {
      result += genre.name + ', ';
    }

    if (result.isEmpty) {
      return result;
    }

    return result.substring(0, result.length - 2);
  }
}
