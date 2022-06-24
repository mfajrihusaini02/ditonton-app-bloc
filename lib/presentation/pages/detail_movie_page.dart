import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/movie/movie.dart';
import 'package:ditonton/domain/entities/movie/movie_detail.dart';
import 'package:ditonton/presentation/bloc/movie/detail_movie/detail_movie_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/detail_movie/detail_movie_event.dart';
import 'package:ditonton/presentation/bloc/movie/detail_movie/detail_movie_state.dart';
import 'package:ditonton/presentation/bloc/movie/recommendation_movie/recommendation_movie_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/watchlist_movie/watchlist_movie_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class DetailMoviePage extends StatefulWidget {
  static const ROUTE_NAME = '/detail';

  final int id;
  DetailMoviePage({required this.id});

  @override
  _DetailMoviePageState createState() => _DetailMoviePageState();
}

class _DetailMoviePageState extends State<DetailMoviePage> {
  @override
  void initState() {
    super.initState();
    context.read<DetailMovieBloc>().add(FetchDetailMovieEvent(widget.id));
    context.read<WatchlistMovieBloc>().add(FetchStatusMovieEvent(widget.id));
    context
        .read<RecommendationMovieBloc>()
        .add(FetchRecommendationMovieEvent(widget.id));
  }

  @override
  Widget build(BuildContext context) {
    RecommendationMovieState movieRecommendations =
        context.watch<RecommendationMovieBloc>().state;

    return Scaffold(
      body: BlocListener<WatchlistMovieBloc, WatchlistMovieState>(
        listener: (_, state) {
          if (state is WatchlistMovieSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.message),
            ));
            context
                .read<WatchlistMovieBloc>()
                .add(FetchStatusMovieEvent(widget.id));
          }
        },
        child: BlocBuilder<DetailMovieBloc, DetailMovieState>(
          builder: (context, state) {
            if (state is DetailMovieLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is DetailMovieLoaded) {
              final movie = state.result;
              bool isAddedToWatchlist = (context
                      .watch<WatchlistMovieBloc>()
                      .state is WatchlistStatusMovieLoaded)
                  ? (context.read<WatchlistMovieBloc>().state
                          as WatchlistStatusMovieLoaded)
                      .result
                  : false;
              return SafeArea(
                child: DetailContent(
                  movie,
                  movieRecommendations is RecommendationMovieLoaded
                      ? movieRecommendations.movie
                      : List.empty(),
                  isAddedToWatchlist,
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
  final MovieDetail movie;
  final List<Movie> recommendations;
  final bool isAddedWatchlist;

  DetailContent(this.movie, this.recommendations, this.isAddedWatchlist);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: 'https://image.tmdb.org/t/p/w500${movie.posterPath}',
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
                              movie.title,
                              style: kHeading5,
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                if (!isAddedWatchlist) {
                                  BlocProvider.of<WatchlistMovieBloc>(context)
                                    ..add(AddItemMovieEvent(movie));
                                } else {
                                  BlocProvider.of<WatchlistMovieBloc>(context)
                                    ..add(RemoveItemMovieEvent(movie));
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
                              _showGenres(movie.genres),
                            ),
                            Text(
                              _showDuration(movie.runtime),
                            ),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: movie.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${movie.voteAverage}')
                              ],
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Overview',
                              style: kHeading6,
                            ),
                            Text(
                              movie.overview,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Recommendations',
                              style: kHeading6,
                            ),
                            BlocBuilder<RecommendationMovieBloc,
                                RecommendationMovieState>(
                              builder: (context, state) {
                                if (state is RecommendationMovieLoading) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (state is RecommendationMovieError) {
                                  return Text(state.message);
                                } else if (state is RecommendationMovieLoaded) {
                                  final recommendations = state.movie;
                                  if (recommendations.isEmpty) {
                                    return const Text(
                                        "No movie recommendations");
                                  }
                                  return Container(
                                    height: 150,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        final movie = recommendations[index];
                                        return Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.pushReplacementNamed(
                                                context,
                                                DetailMoviePage.ROUTE_NAME,
                                                arguments: movie.id,
                                              );
                                            },
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(8),
                                              ),
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    'https://image.tmdb.org/t/p/w500${movie.posterPath}',
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

  String _showDuration(int runtime) {
    final int hours = runtime ~/ 60;
    final int minutes = runtime % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }
}
