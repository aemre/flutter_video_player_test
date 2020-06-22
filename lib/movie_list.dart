import 'package:flutter/material.dart';
import 'package:flutterapp/blocs/movie_detail_bloc_provider.dart';
import 'package:flutterapp/movie_detail.dart';
import 'package:flutterapp/blocs/movies_bloc.dart';
import 'package:flutterapp/models/item_model.dart';

import 'TransparentRoute.dart';

class MovieList extends StatefulWidget {
  @override
  MovieListState createState() {
    return new MovieListState();
  }
}

class MovieListState extends State<MovieList> {
  @override
  void initState() {
    super.initState();
    bloc.fetchAllMovies();
  }

  @override
  void dispose() {
    super.dispose();
   // bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: MediaQuery
              .of(context)
              .size
              .height / 2,
          color: Colors.black,
          child: StreamBuilder(
            stream: bloc.allMovies,
            builder: ((context, snapshot) {
              if (snapshot.hasData) {
                return buildList(snapshot);
              } else if (snapshot.hasError) {
                print("Inside hasError");
                return Text(snapshot.error.toString());
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            }),
          ),
        ),

      ),
    );
  }

  Widget buildList(AsyncSnapshot<ItemModel> snapshot) {
    return

      ListView.builder(
        itemCount: snapshot.data.results.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0)
            ),
            child: InkResponse(
              splashColor: Colors.black,
              enableFeedback: true,
              child: Image.network(
                'https://image.tmdb.org/t/p/w185${snapshot.data.results[index]
                    .poster_path}',
                fit: BoxFit.fill,
              ),
              onTap: () => goToMoviesDetailPage(snapshot.data, index),
            ),
          );
        },
      );
  }

  goToMoviesDetailPage(ItemModel data, int index) {
    Navigator.of(context).pushReplacement(
      TransparentRoute(
          builder: (context) =>
              Scaffold(
                appBar: null,
                backgroundColor: Colors.transparent,
                body: Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: MediaQuery
                        .of(context)
                        .size
                        .height / 2,
                    color: Colors.black,
                    child: MovieDetailBlocProvider(
                      child:
                      MovieDetailScreen(
                        title: data.results[index].title,
                        posterUrl: data.results[index].poster_path,
                        description: data.results[index].overview,
                        releaseDate: data.results[index].release_date,
                        voteAverage: data.results[index].vote_average
                            .toString(),
                        movieId: data.results[index].id,
                      ),
                    ),
                  ),
                ),
              )
      ),
    );
  }
}
