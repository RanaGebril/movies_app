import 'package:flutter/material.dart';
import 'package:movies_app/AppColors.dart';
import 'package:movies_app/api_manager.dart';
import 'package:movies_app/home/slider_widget.dart';

class PopularUi extends StatelessWidget {
  const PopularUi({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ApiManager.getPopularMovies(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Something went wrong!',
              style: TextStyle(color: Appcolors.whiteColor),
            ),
          );
        }

        var popularMovies = snapshot.data?.results ?? [];

        return Stack(
          children: [

            SliderWidget(
              movies: popularMovies,
              imageUrlBuilder: (index) =>
              "https://image.tmdb.org/t/p/w500${popularMovies[index].backdropPath ?? ''}",
              titleBuilder: (index) => popularMovies[index].title ?? 'No Title',
              subtitleBuilder: (index) =>
              popularMovies[index].releaseDate ?? 'No Release Date',
              displayBookmark: false,
              height: 300,
              top: 0,
              left: 0,
              right: 0,
              showPlayIcon: true,
            ),


            SliderWidget(
              movies: popularMovies,
              imageUrlBuilder: (index) =>
              "https://image.tmdb.org/t/p/w500${popularMovies[index].backdropPath ?? ''}",
              displayBookmark: true,
              height: 199,
              top: 130,
              left: 30,
              right: 200,
              showPlayIcon: false,
              borderRadius: 10,
            ),
          ],
        );
      },
    );
  }
}
