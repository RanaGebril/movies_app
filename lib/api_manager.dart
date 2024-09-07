import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movies_app/browes_screen/BrowseCategory.dart';
import 'package:movies_app/browes_screen/MoviesOfCategory.dart';
import 'package:movies_app/home/PopularMovies.dart';
import 'package:movies_app/home/TopRated.dart';
import 'package:movies_app/home/UpComing_Movies.dart';
import 'package:movies_app/search_screen/searchresult.dart';
class ApiManager {
  static Future<PopularMovies> getPopularMovies() async {
    Uri url = Uri.https('api.themoviedb.org', '/3/movie/popular', {
      'api_key': '86199a6c3796f9c1d6a1a79fca08dea4',
      'language': 'en-US',
      'page': '1',
    });

    http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      return PopularMovies.fromJson(json);
    } else {
      throw Exception(
          'Failed to load popular movies. Status code: ${response.statusCode}');
    }
  }

  static Future<UpComing_Movies> getUpComingMovies() async {
    Uri url = Uri.https('api.themoviedb.org', '/3/movie/upcoming', {
      'api_key': '86199a6c3796f9c1d6a1a79fca08dea4',
      'language': 'en-US',
      'page': '1',
    });

    http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      return UpComing_Movies.fromJson(json);
    } else {
      throw Exception(
          'Failed to load upcoming movies. Status code: ${response
              .statusCode}');
    }
  }

  static Future<Top_Rated> getTopRatedMovies() async {
    Uri url = Uri.https('api.themoviedb.org', '/3/movie/top_rated', {
      'api_key': '86199a6c3796f9c1d6a1a79fca08dea4',
      'language': 'en-US',
      'page': '1',
    });

    http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      return Top_Rated.fromJson(json);
    } else {
      throw Exception(
          'Failed to load top rated movies. Status code: ${response
              .statusCode}');
    }
  }

  static Future<BrowseCategory> getBrowseCategories() async {
    Uri url = Uri.https('api.themoviedb.org', '/3/genre/movie/list', {
      'api_key': '86199a6c3796f9c1d6a1a79fca08dea4',
      'language': 'en-US',
    });

    http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      return BrowseCategory.fromJson(json);
    } else {
      throw Exception(
          'Failed to load browse categories. Status code: ${response
              .statusCode}');
    }
  }

  // New method to fetch movies by category
  static Future<MoviesOfCategory> getMoviesByCategory(int genreId) async {
    Uri url = Uri.https('api.themoviedb.org', '/3/discover/movie', {
      'api_key': '86199a6c3796f9c1d6a1a79fca08dea4',
      'language': 'en-US',
      'sort_by': 'popularity.desc',
      'with_genres': genreId.toString(),
      'page': '1',
    });

    http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      return MoviesOfCategory.fromJson(json);
    } else {
      throw Exception(
          'Failed to load movies by category. Status code: ${response
              .statusCode}');
    }
  }

  //search
  static Future<SearchResult> searchMoviesByName(String movieName) async {
    Uri url = Uri.https('api.themoviedb.org', '/3/search/movie', {
      'api_key': '86199a6c3796f9c1d6a1a79fca08dea4',
      'language': 'en-US',
      'query': movieName,
      'page': '1',
      'include_adult': 'false',
    });

    http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      return SearchResult.fromJson(json);
    } else {
      throw Exception(
          'Failed to search movies. Status code: ${response.statusCode}');
    }
  }

  //main actors of the film
  static Future<List<String>> getMovieCredits(int movieId) async {
    Uri url = Uri.https('api.themoviedb.org', '/3/movie/$movieId/credits', {
      'api_key': '86199a6c3796f9c1d6a1a79fca08dea4',
      'language': 'en-US',
    });

    http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      // Extract the top-billed cast (heroes)
      List<dynamic> cast = json['cast'] ?? [];
      // Map the cast to a list of actor names
      List<String> actors = cast.map((actor) => actor['name'].toString()).toList();
      return actors;
    } else {
      throw Exception('Failed to load movie credits. Status code: ${response.statusCode}');
    }
  }
}
