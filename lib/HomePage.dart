import 'package:flutter/material.dart';
import 'package:movies_app/AppColors.dart';
import 'package:movies_app/Browse.dart';
import 'package:movies_app/WatchList.dart';
import 'package:movies_app/api_manager.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:movies_app/search_provider.dart';
import 'package:movies_app/search_tab.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  static const String routeName = 'home';
  final TextEditingController _searchController = TextEditingController();


  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolors.primary,
      body: FutureBuilder(
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
              // Carousel Slider for Popular Movies
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child:
                CarouselSlider.builder(
                  itemCount: popularMovies.length,
                  itemBuilder: (context, index, realIndex) {
                    String imageUrl =
                        "https://image.tmdb.org/t/p/w500${popularMovies[index].backdropPath ?? ''}";
                    String title = popularMovies[index].title ?? 'No Title';
                    String releaseDate =
                        popularMovies[index].releaseDate ?? 'No Release Date';

                    return imageUrl.isNotEmpty &&
                        popularMovies[index].backdropPath != null
                        ? Container(
                      height: 300,
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
                                  errorBuilder:
                                      (context, error, stackTrace) {
                                    return Center(
                                      child: Icon(
                                        Icons.broken_image,
                                        color: Appcolors.whiteColor,
                                      ),
                                    );
                                  },
                                ),
                                Center(child: Icon(Icons.play_circle_sharp, color: Appcolors.whiteColor, size: 40,)),
                                // Display bookmark and add icons on the second movie image
                                if (index == 1)
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
                                            color: Appcolors.whiteColor,
                                            size: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Container(
                                padding: EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  title,
                                  style: Theme.of(context).textTheme.bodyLarge,
                                  textAlign: TextAlign.right,
                                ),
                                SizedBox(height: 4.0),
                                Text(
                                  releaseDate,
                                  style:Theme.of(context).textTheme.bodyMedium,
                                  textAlign: TextAlign.right,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                        : Container(
                      color: Appcolors.primary,
                      child: Center(
                        child: Text(
                          'No Image Available',
                          style: TextStyle(color: Appcolors.whiteColor,),
                        ),
                      ),
                    );
                  },
                  options: CarouselOptions(
                    height: 300,
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 3),
                    autoPlayAnimationDuration: Duration(milliseconds: 300),
                    enlargeCenterPage: true,
                    viewportFraction: 1.0,
                  ),
                ),
              ),

              // PageView for Popular Movies on Top-Right
              Positioned(
                top: 118, // Adjust this based on where you want to position the PageView
                left: 30,
                child: Container(
                  width: 129,
                  height: 199,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(4),
                    ),
                    color: Colors.transparent,
                  ),
                  child: Stack(
                    children: [
                      CarouselSlider.builder(
                        itemCount: popularMovies.length,
                        itemBuilder: (context, index, realIndex) {
                          String imageUrl = "https://image.tmdb.org/t/p/w500${popularMovies[index].backdropPath ?? ''}";

                          return imageUrl.isNotEmpty && popularMovies[index].backdropPath != null
                              ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.broken_image,
                                  color: Appcolors.whiteColor,
                                );
                              },
                            ),
                          )
                              : Container(
                            color: Colors.grey[800],
                            child: Center(
                              child: Text(
                                'No Image Available',
                                style: TextStyle(color: Appcolors.whiteColor),
                              ),
                            ),
                          );
                        },
                        options: CarouselOptions(
                          height: 300,
                          autoPlay: true,
                          autoPlayInterval: Duration(seconds: 3),
                          autoPlayAnimationDuration: Duration(milliseconds: 300),
                          enlargeCenterPage: true,
                          viewportFraction: 1.0,
                        ),
                      ),

                      Stack(
                        children: [
                          Icon(
                            Icons.bookmark,
                            color: Colors.white10,
                          ),
                          Icon(
                            Icons.add,
                            color: Appcolors.whiteColor,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Rest of the UI (New Releases and Top Rated Sections)
              Positioned(
                top: 350, // Adjust based on the space needed for the sections
                left: 0,
                right: 0,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // New Release Section
                      Container(
                        width: double.infinity,
                        color: Appcolors.secondary,
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'New Release',
                              style:Theme.of(context).textTheme.bodyLarge?.copyWith(
                                fontSize: 20
                              ),
                            ),
                            SizedBox(height: 10),
                            FutureBuilder(
                              future: ApiManager.getUpComingMovies(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return Center(child: CircularProgressIndicator());
                                }

                                if (snapshot.hasError) {
                                  return Center(
                                    child: Text(
                                      'Something went wrong!',
                                      style: TextStyle(color: Appcolors.whiteColor,),
                                    ),
                                  );
                                }

                                var upcomingMovies = snapshot.data?.results ?? [];

                                return Container(
                                  height: 150,
                                  width: double.infinity,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: upcomingMovies.length,
                                    itemBuilder: (context, index) {
                                      String imageUrl =
                                          "https://image.tmdb.org/t/p/w500${upcomingMovies[index].posterPath ?? ''}";

                                      return Container(
                                        width: 90,
                                        margin: EdgeInsets.symmetric(horizontal: 8.0),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(8.0),
                                          child: Stack(
                                            children: [
                                              Image.network(
                                                imageUrl,
                                                fit: BoxFit.fill,
                                                errorBuilder: (context, error, stackTrace) {
                                                  return Center(
                                                    child: Icon(
                                                      Icons.broken_image,
                                                      color: Appcolors.whiteColor,
                                                    ),
                                                  );
                                                },
                                              ),
                                              Stack(
                                                children: [
                                                  Icon(
                                                    Icons.bookmark,
                                                    // Change the color based on the index
                                                    color: index == 1 ? Colors.yellow : Colors.white10,
                                                  ),
                                                  Icon(
                                                    // Change the icon based on the index value
                                                     index == 1 ? Icons.check: Icons.add, // Use `Icons.check` instead of `Icons.ok`
                                                    color: Appcolors.whiteColor,
                                                  ),
                                                ],
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
                      ),

                      SizedBox(height: 15),

                      // Top Rated Section
                      Container(
                        width: double.infinity,
                        color: Colors.grey[850],
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Recommended',
                              style:Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  fontSize: 20
                              ),
                            ),
                            SizedBox(height: 10),
                            FutureBuilder(
                              future: ApiManager.getTopRatedMovies(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return Center(child: CircularProgressIndicator());
                                }

                                if (snapshot.hasError) {
                                  return Center(
                                    child: Text(
                                      'Something went wrong!',
                                      style: TextStyle(color: Appcolors.whiteColor,),
                                    ),
                                  );
                                }

                                var topRatedMovies = snapshot.data?.results ?? [];

                                return Container(
                                  height: 200, // Adjusted height for better visibility
                                  width: double.infinity,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: topRatedMovies.length,
                                    itemBuilder: (context, index) {
                                      String imageUrl =
                                          "https://image.tmdb.org/t/p/w500${topRatedMovies[index].posterPath ?? ''}";
                                      String title = topRatedMovies[index].title ?? 'No Title';
                                      String releaseDate = topRatedMovies[index].releaseDate ?? 'No Release Date';
                                      double voteAverage = topRatedMovies[index].voteAverage ?? 0.0;

                                      return Container(
                                        width: 100,
                                      // Adjusted width to fit better within the container
                                        margin: EdgeInsets.symmetric(horizontal: 8.0),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[830], // Background color
                                          borderRadius: BorderRadius.circular(8.0),
                                          border: Border.all(color: Colors.grey[700]!, width: 2.0), // Border color and width
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: double.infinity,
                                              height: 100,
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.vertical(top: Radius.circular(8.0)),
                                                child: Stack(
                                                  children: [
                                                    Image.network(
                                                      imageUrl,
                                                      fit: BoxFit.cover, // Changed to cover to fit the image better
                                                      width: double.infinity,
                                                      errorBuilder: (context, error, stackTrace) {
                                                        return Center(
                                                          child: Icon(
                                                            Icons.broken_image,
                                                            color: Appcolors.whiteColor,
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                    Stack(
                                                      children: [
                                                        Icon(
                                                          Icons.bookmark,
                                                          color: Colors.white10,
                                                        ),
                                                        Icon(
                                                          Icons.add,
                                                          color: Appcolors.whiteColor,
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                                        voteAverage.toStringAsFixed(1),
                                                        style: TextStyle(
                                                          color: Appcolors.whiteColor,
                                                          fontSize: 14.0,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Text(
                                                    title,
                                                    style: TextStyle(
                                                      color: Appcolors.whiteColor,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 16.0,
                                                    ),
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                  ),
                                                  SizedBox(height: 4.0),
                                                  Text(
                                                    releaseDate,
                                                    style: TextStyle(
                                                      color: Appcolors.whiteColor,
                                                      fontSize: 14.0,
                                                    ),
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                  ),
                                                  SizedBox(height: 4.0),

                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar:Container(
        color:Color(0xff1a1a1a) ,
        child: Row(
          children: [
            Spacer(),
            IconButton(
                onPressed:() {
                  Navigator.pushNamed(context,HomePage.routeName);
                }, icon:Icon(Icons.home_sharp,
              color: Appcolors.whiteColor
            )),
            Spacer(),
            IconButton(onPressed:() {
              showSearch(context: context, delegate: SearchTab(
                searchProvider: Provider.of<SearchProvider>(context, listen: false),
              ),
              );//  context: context,
             // delegate: CustomSearchDelegate(),
            }, icon:Icon(Icons.search,color:Appcolors.whiteColor)),
            Spacer(),
            IconButton(onPressed:() {
              Navigator.pushNamed(context,Browse.routeName);
            }, icon:Icon(Icons.movie_creation,color:Appcolors.whiteColor)),
            Spacer(),
            IconButton(onPressed:() {
              Navigator.pushNamed(context,WatchKListScreen.routeName);
            }, icon:Icon(Icons.collections_bookmark,color:Appcolors.whiteColor)),
            Spacer(),

          ],

        ),
      ),

    );
  }
}
