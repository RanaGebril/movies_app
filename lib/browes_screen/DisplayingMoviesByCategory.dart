import 'package:flutter/material.dart';
import 'package:movies_app/AppColors.dart';
import 'package:movies_app/browes_screen/MoviesOfCategory.dart';
import 'package:movies_app/api_manager.dart';

class MoviesByCategoryScreen extends StatefulWidget {
  final int categoryId;

  MoviesByCategoryScreen({required this.categoryId, Key? key})
      : super(key: key);

  @override
  _MoviesByCategoryScreenState createState() => _MoviesByCategoryScreenState();
}

class _MoviesByCategoryScreenState extends State<MoviesByCategoryScreen> {
  late Future<MoviesOfCategory> _moviesOfCategoryFuture;

  @override
  void initState() {
    super.initState();
    _moviesOfCategoryFuture = ApiManager.getMoviesByCategory(widget.categoryId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movies'),
      ),
      backgroundColor: Appcolors.primary,
      body: FutureBuilder<MoviesOfCategory>(
        future: _moviesOfCategoryFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.results == null) {
            return Center(child: Text('No movies available'));
          } else {
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
              ),
              padding: EdgeInsets.all(10.0),
              itemCount: snapshot.data!.results!.length,
              itemBuilder: (context, index) {
                var movie = snapshot.data!.results![index];
                String posterUrl =
                    'https://image.tmdb.org/t/p/w500${movie.posterPath}';

                return GridTile(
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(posterUrl),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Center(
                      child: Text(movie.title ?? '',
                          style: Theme.of(context).textTheme.titleMedium),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
