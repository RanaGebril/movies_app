import 'package:flutter/material.dart';
import 'package:movies_app/api_manager.dart';
import 'package:movies_app/firebase_functions.dart';
import 'package:movies_app/movie%20_details/movie_details_screen.dart';
import 'package:movies_app/watch_list/whatch_list_model.dart';

class Recommended extends StatelessWidget {
  const Recommended({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.grey[850],
      padding: EdgeInsets.symmetric(
          vertical: 10, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recommended',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),
          FutureBuilder(
            future: ApiManager.getTopRatedMovies(),
            builder: (context, snapshot) {
              if (snapshot.connectionState ==
                  ConnectionState.waiting) {
                return Center(
                    child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Something went wrong!',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }

              var topRatedMovies = snapshot.data?.results ??
                  [];

              return Container(
                height: 150,
                // Adjusted height for better visibility
                width: double.infinity,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: topRatedMovies.length,
                  itemBuilder: (context, index) {
                    String imageUrl =
                        "https://image.tmdb.org/t/p/w500${topRatedMovies[index]
                        .posterPath ?? ''}";
                    String title = topRatedMovies[index]
                        .title ?? 'No Title';
                    String releaseDate = topRatedMovies[index]
                        .releaseDate ?? 'No Release Date';
                    double voteAverage = topRatedMovies[index]
                        .voteAverage ?? 0.0;
                    int movieId = topRatedMovies[index].id ??
                        0;

                    return Container(
                      width: 100,
                      margin: EdgeInsets.symmetric(
                          horizontal: 8.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[830],
                        // Background color
                        borderRadius: BorderRadius.circular(
                            8.0),
                        border: Border.all(
                            color: Colors.grey[700]!,
                            width: 2.0), // Border color and width
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            MovieDetailsScreen.routeName,
                            arguments: topRatedMovies[index]
                                .id,
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment
                              .start,
                          children: [
                            Container(
                              width: double.infinity,
                              height: 100,
                              child: ClipRRect(
                                borderRadius: BorderRadius
                                    .vertical(
                                    top: Radius.circular(
                                        8.0)),
                                child: Stack(
                                  children: [
                                    Image.network(
                                      imageUrl,
                                      fit: BoxFit.cover,
                                      // Changed to cover to fit the image better
                                      width: double.infinity,
                                      errorBuilder: (context,
                                          error, stackTrace) {
                                        return Center(
                                          child: Icon(
                                            Icons
                                                .broken_image,
                                            color: Colors
                                                .white,
                                          ),
                                        );
                                      },
                                    ),
                                    Positioned(
                                      top: 8,
                                      left: 8,
                                      // Align to the top left
                                      child: GestureDetector(
                                        onTap: () async {
                                          var movie = topRatedMovies[index];
                                          await FirebaseFunctions
                                              .addMovie(
                                              MovieModelWatchList(
                                                title: movie
                                                    .title ??
                                                    '',
                                                imageUrl: "https://image.tmdb.org/t/p/w500${movie
                                                    .posterPath ??
                                                    ''}",
                                                releaseDate: movie
                                                    .releaseDate ??
                                                    '',
                                                id: '', // ID will be set by Firestore
                                              ));
                                          ScaffoldMessenger
                                              .of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content: Text(
                                                    'Movie added to watchlist')),
                                          );
                                        },
                                        child: Stack(
                                          children: [
                                            Icon(
                                              Icons.bookmark,
                                              color: Colors
                                                  .white10,
                                            ),
                                            Icon(
                                              Icons.add,
                                              color: Colors
                                                  .white,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(
                                  8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment
                                    .start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.star,
                                        color: Colors.yellow,
                                        size: 16.0,
                                      ),
                                      SizedBox(width: 4.0),
                                      Text(
                                        voteAverage
                                            .toStringAsFixed(
                                            1),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    title,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight
                                          .bold,
                                      fontSize: 16.0,
                                    ),
                                    overflow: TextOverflow
                                        .ellipsis,
                                    maxLines: 1,
                                  ),
                                  SizedBox(height: 4.0),
                                  Text(
                                    releaseDate,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14.0,
                                    ),
                                    overflow: TextOverflow
                                        .ellipsis,
                                    maxLines: 1,
                                  ),
                                  SizedBox(height: 4.0),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
