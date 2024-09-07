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
            // Carousel Slider for Popular Movies with titles and subtitles
            // SliderWidget(
            //   movies: popularMovies,
            //   imageUrlBuilder: (index) =>
            //   "https://image.tmdb.org/t/p/w500${popularMovies[index].backdropPath ?? ''}",
            //   titleBuilder: (index) => popularMovies[index].title ?? 'No Title',
            //   subtitleBuilder: (index) =>
            //   popularMovies[index].releaseDate ?? 'No Release Date',
            //   displayBookmark: true,
            //   height: 300,  // Full-width slider height
            //   top: 0,
            //   left: 0,
            //   right: 0,
            // ),

            // Second Slider with only images
            // SliderWidget(
            //   movies: popularMovies,
            //   imageUrlBuilder: (index) =>
            //   "https://image.tmdb.org/t/p/w500${popularMovies[index].backdropPath ?? ''}",
            //   displayBookmark: false,
            //   //height: ,  // Different height
            //   //width: 50,   // Smaller width
            //   top: 100,     // Positioned below the first slider
            //   left: 30,
            //   right: 150,   // Positioned to the right
            // ),
          ],
        );
      },
    );
  }
}
