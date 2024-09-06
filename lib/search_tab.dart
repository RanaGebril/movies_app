import 'package:flutter/material.dart';
import 'package:movies_app/search_provider.dart';
import 'package:provider/provider.dart'; // Update with your actual path

class SearchTab extends SearchDelegate<String> {
  final SearchProvider searchProvider;
  late Future<void> searchFuture;

  SearchTab({required this.searchProvider}) {
    searchFuture = searchProvider.searchMovies(query);
  }

  @override
  TextStyle? get searchFieldStyle => TextStyle(
    color: Colors.black, // Change text color
    fontSize: 16.0, // Change font size
  );

  @override
  InputDecorationTheme get searchFieldDecorationTheme => InputDecorationTheme(
    contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30.0), // Rounded corners
      borderSide: BorderSide.none, // Remove border
    ),
    fillColor: Colors.grey[200], // Background color
    filled: true,
    //hintText: 'Search movies...',
    hintStyle: TextStyle(
      color: Colors.grey[600], // Hint text color
    ),
    // // Search icon inside the search bar
  );

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear, color: Colors.red),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back, color: Colors.blue),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    searchFuture = searchProvider.searchMovies(query); // Update future with the new query

    return FutureBuilder(
      future: searchFuture,
      builder: (context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            color: Colors.black,
            child: Center(
              child: CircularProgressIndicator(color: Colors.blueGrey),
            ),
          );
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.red)));
        }

        final movies = searchProvider.movies;

        if (movies.isEmpty) {
          return Container(
            color: Colors.black,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.local_movies,
                    size: 100,
                    color: Colors.blueGrey,
                  ),
                  SizedBox(height: 5),
                  Text(
                    'No result found',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.blueGrey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        return Container(
          color: Colors.black,
          child: ListView.separated(
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12), // Border radius of 12
                        child: Image.network(
                          'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                          width: 120,
                          height: 180,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            // Fallback image if the network image fails to load
                            return Icon(Icons.movie_creation_sharp,
                            color: Colors.blueGrey,
                            size: 100,);
                          },
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            movie.title ?? 'No Title',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            movie.getYear(),
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            movie.actors != null && movie.actors!.isNotEmpty
                                ? 'Heroes: ${movie.actors!.take(3).join(', ')}' // Showing top 3 heroes
                                : 'No Heroes Found',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) => Divider(
              color: Colors.grey[400],
              thickness: 1,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Center(
      child: Container(
        color: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(
              Icons.local_movies,
              size: 100,
              color: Colors.blueGrey,
            ),
            SizedBox(height: 5),
            Text(
              'Search for your favorite movies',
              style: TextStyle(
                fontSize: 13,
                color: Colors.blueGrey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
