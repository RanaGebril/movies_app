import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class SliderWidget extends StatelessWidget {
  List movies;
  String Function(int index)? imageUrlBuilder;
  String Function(int index)? titleBuilder;
  String Function(int index)? subtitleBuilder;
  bool displayBookmark;
  double width;
  double height;
  double top;
  double left;
  double right;

  SliderWidget({
    required this.movies,
    this.imageUrlBuilder,
    this.titleBuilder,
    this.subtitleBuilder,
    this.displayBookmark = false,
    this.width = double.infinity,
    this.height = 300,
    this.top = 0,
    this.left = 0,
    this.right = 0,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      child: Container(
        width: width,
        height: height,
        child: CarouselSlider.builder(
          itemCount: movies.length,
          itemBuilder: (context, index, realIndex) {
            String imageUrl = imageUrlBuilder != null
                ? imageUrlBuilder!(index)
                : "https://image.tmdb.org/t/p/w500${movies[index].backdropPath ?? ''}";
            String title = titleBuilder != null
                ? titleBuilder!(index)
                : '';
            String subtitle = subtitleBuilder != null
                ? subtitleBuilder!(index)
                : '';

            return imageUrl.isNotEmpty
                ? Container(
              height: height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Icon(
                                Icons.broken_image,
                                color: Colors.white,
                              ),
                            );
                          },
                        ),
                        Center(
                          child: Icon(Icons.play_circle_sharp,
                              color: Colors.white, size: 40),
                        ),
                        if (displayBookmark && index == 1)
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Stack(
                              children: [
                                Icon(
                                  Icons.bookmark,
                                  color: Colors.white12,
                                  size: 30,
                                ),
                                Positioned(
                                  right: 0,
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (title.isNotEmpty || subtitle.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (title.isNotEmpty)
                            Text(
                              title,
                              style: Theme.of(context).textTheme.bodyLarge,
                              textAlign: TextAlign.right,
                            ),
                          if (subtitle.isNotEmpty)
                            Text(
                              subtitle,
                              style: Theme.of(context).textTheme.bodyMedium,
                              textAlign: TextAlign.right,
                            ),
                        ],
                      ),
                    ),
                ],
              ),
            )
                : SizedBox.shrink();
          },
          options: CarouselOptions(
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 3),
            autoPlayAnimationDuration: Duration(milliseconds: 300),
            enlargeCenterPage: true,
            viewportFraction: 1.0,
          ),
        ),
      ),
    );
  }
}
