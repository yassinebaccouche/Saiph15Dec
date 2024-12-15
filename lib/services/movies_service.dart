import 'dart:convert';

import 'package:http/http.dart' as http;

import '../Models/movie.dart';

class MovieService{
  static String urlPopular = 'https://api.themoviedb.org/3/movie/popular?language=en-US&page=1';
  static String urlGenre = 'https://api.themoviedb.org/3/genre/movie/list';
  static String urlTopRated = 'https://api.themoviedb.org/3/movie/top_rated';
  static String urlUpcoming = 'https://api.themoviedb.org/3/movie/upcoming';
  static Map<String,String> headers = {
    'Authorization':
    'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI3NDAxZGFmNzNiNjkwMjg3MWMyNjliNDUwMDYwYTU0ZCIsInN1YiI6IjY0ODVhZjkzZDJiMjA5MDBhZDNjZDRlZiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.rMBuhQeb9ARqpghB7oENl1EVvFd_eA-wiUc8xzK7fXU',
    'accept': 'application/json',
  };
  static final client = http.Client();

  static Future<List<Movie>?> getPopularMovies() async{
  Uri uri = Uri.parse(urlPopular);
  try {
    http.Response response = await client.get(uri, headers:headers);
    Map<String, dynamic> body = jsonDecode(response.body);
    List<Movie> result = <Movie>[];
    if (response.statusCode == 200) {
      List<dynamic> resp = body['results'];
      for (var element in resp) {
        result.add(Movie.fromJson(element));
      }
      return result;
    }
    if (response.statusCode == 404) {
      return result;
    }
  } catch (e) {
    return null;
  }
  return null;
  }
  static Future<List<Movie>?> getTopRatedMovies() async{
  Uri uri = Uri.parse(urlTopRated);
  try {
    http.Response response = await client.get(uri, headers:headers);
    Map<String, dynamic> body = jsonDecode(response.body);
    List<Movie> result = <Movie>[];
    if (response.statusCode == 200) {
      List<dynamic> resp = body['results'];
      for (var element in resp) {
        result.add(Movie.fromJson(element));
      }
      return result;
    }
    if (response.statusCode == 404) {
      return result;
    }
  } catch (e) {
    return null;
  }
  return null;
  }
  static Future<List<Movie>?> getUpcomingMovies() async{
  Uri uri = Uri.parse(urlUpcoming);
  try {
    http.Response response = await client.get(uri, headers:headers);
    Map<String, dynamic> body = jsonDecode(response.body);
    List<Movie> result = <Movie>[];
    if (response.statusCode == 200) {
      List<dynamic> resp = body['results'];
      for (var element in resp) {
        result.add(Movie.fromJson(element));
      }
      return result;
    }
    if (response.statusCode == 404) {
      return result;
    }
  } catch (e) {
    return null;
  }
  return null;
  }

  static Future<List<String>?> getCategories(List<int> categoriesID) async{
    Uri uri = Uri.parse(urlGenre);
    try {
      http.Response response = await client.get(uri, headers:headers);
      Map<String, dynamic> body = jsonDecode(response.body);
      List<String>? result=[];
      if (response.statusCode == 200) {
        List<dynamic> resp = body['genres'];
        for (var element in resp) {
          if(categoriesID.contains(element['id'])){
            result.add(element['name']);
          }
        }
        return result;
      }
      if (response.statusCode == 404) {
        return result;
      }
    } catch (e) {
      return null;
    }
    return null;
  }
}