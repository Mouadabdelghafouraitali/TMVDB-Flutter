import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:themoviesdb/Models/ByPerson.dart';
import 'package:themoviesdb/Models/Credits.dart';
import 'package:themoviesdb/Models/GenresModel/Genre.dart' as Genre_;
import 'package:themoviesdb/Models/GenresModel/GenreList.dart';
import 'package:themoviesdb/Models/GenresModel/GenreTV.dart';
import 'package:themoviesdb/Models/Movie.dart';
import 'package:themoviesdb/Models/Movies.dart';
import 'package:themoviesdb/Models/OnTheAir.dart';
import 'package:themoviesdb/Models/Person.dart';
import 'package:themoviesdb/Models/Reviews.dart';
import 'package:themoviesdb/Models/SearchModel/SearchMovie.dart';
import 'package:themoviesdb/Models/SearchModel/SearchTVShow.dart';
import 'package:themoviesdb/Models/SeasonInfo.dart';
import 'package:themoviesdb/Models/Similar.dart';
import 'package:themoviesdb/Models/SimilarTVShow.dart';
import 'package:themoviesdb/Models/TVShow.dart';
import 'package:themoviesdb/Models/TVShows.dart';
import 'package:themoviesdb/Models/Trending.dart';
import 'package:themoviesdb/Models/Videos.dart';
import 'package:themoviesdb/Utils/Constants.dart';

class FutureHelper {
  static Future<OnTheAir> getOnTheAir() async {
    String BASEURL = on_the_air + api_key_str + api_key;
    var response = await http.get((BASEURL));
    var jsonData = jsonDecode(response.body);
    return OnTheAir.fromJson(jsonData);
  }

  static Future<TVShow> getNextEpisodeInfo(int id) async {
    String BASEURL = next_episode + id.toString() + api_key_str + api_key;
    var response = await http.get((BASEURL));
    var jsonData = jsonDecode(response.body);
    return TVShow.fromJson(jsonData);
  }

  static Future<Movies> getOnPlayingNow() async {
    String BASEURL = now_playing + api_key_str + api_key;
    var response = await http.get((BASEURL));
    var jsonData = jsonDecode(response.body);
    return Movies.fromJson(jsonData);
  }

  static Future<Trending> getTrendingToday() async {
    String BASEURL = trending_today + api_key_str + api_key;
    var response = await http.get((BASEURL));
    var jsonData = jsonDecode(response.body);
    return Trending.fromJson(jsonData);
  }

  static Future<Trending> getTrendingWeek() async {
    String BASEURL = trending_week + api_key_str + api_key;
    var response = await http.get((BASEURL));
    var jsonData = jsonDecode(response.body);
    return Trending.fromJson(jsonData);
  }

  static Future<Credits> getCredits(int id, String type) async {
    String BASEURL = type + id.toString() + credits + api_key_str + api_key;
    var response = await http.get((BASEURL));
    var jsonData = jsonDecode(response.body);
    return Credits.fromJson(jsonData);
  }

  static Future<Movie> getMovie(int id) async {
    String BASEURL = movie + id.toString() + api_key_str + api_key;
    var response = await http.get((BASEURL));
    var jsonData = jsonDecode(response.body);
    return Movie.fromJson(jsonData);
  }

  static Future<Videos> getVideos(int id) async {
    String BASEURL = movie + id.toString() + videos + api_key_str + api_key;
    var response = await http.get((BASEURL));
    var jsonData = jsonDecode(response.body);
    return Videos.fromJson(jsonData);
  }

  static Future<Reviews> getReviews(int id) async {
    String BASEURL = movie + id.toString() + reviews + api_key_str + api_key;
    var response = await http.get((BASEURL));
    var jsonData = jsonDecode(response.body);
    return Reviews.fromJson(jsonData);
  }

  static Future<Similar> getSimilarMovies(int id) async {
    String BASEURL = movie + id.toString() + similar + api_key_str + api_key;
    var response = await http.get((BASEURL));
    var jsonData = jsonDecode(response.body);
    return Similar.fromJson(jsonData);
  }

  static Future<Genre_.Genre> getGenres(int id) async {
    String BASEURL = genres_movie + api_key_str + api_key + with_genres + id.toString();
    var response = await http.get((BASEURL));
    var jsonData = jsonDecode(response.body);
    return Genre_.Genre.fromJson(jsonData);
  }

  static Future<GenreTv> getGenresTV(int id) async {
    String BASEURL = genres_tv + api_key_str + api_key + with_genres + id.toString();
    var response = await http.get((BASEURL));
    var jsonData = jsonDecode(response.body);
    return GenreTv.fromJson(jsonData);
  }

  static Future<GenreList> getListGenres() async {
    String BASEURL = list_genres + api_key_str + api_key;
    var response = await http.get((BASEURL));
    var jsonData = jsonDecode(response.body);
    return GenreList.fromJson(jsonData);
  }

  static Future<Person> getPerson(int id) async {
    String BASEURL = person + id.toString() + api_key_str + api_key;
    var response = await http.get((BASEURL));
    var jsonData = jsonDecode(response.body);
    return Person.fromJson(jsonData);
  }

  static Future<ByPerson> getByPerson(int id) async {
    String BASEURL = person + id.toString() + combined_credits + api_key_str + api_key;
    var response = await http.get((BASEURL));
    var jsonData = jsonDecode(response.body);
    return ByPerson.fromJson(jsonData);
  }

  static Future<TVShow> getTVShow(int id) async {
    String BASEURL = tv_show + id.toString() + api_key_str + api_key + '&append_to_response';
    var response = await http.get((BASEURL));
    var jsonData = jsonDecode(response.body);
    return TVShow.fromJson(jsonData);
  }

  static Future<SeasonInfo> getSeasonInformation(int id, int number) async {
    String BASEURL = tv_show + id.toString() + season + number.toString() + api_key_str + api_key;
    var response = await http.get((BASEURL));
    var jsonData = jsonDecode(response.body);
    return SeasonInfo.fromJson(jsonData);
  }

  static Future<Videos> getTVShowVideos(int id) async {
    String BASEURL = tv_show + id.toString() + videos + api_key_str + api_key;
    var response = await http.get((BASEURL));
    var jsonData = jsonDecode(response.body);
    return Videos.fromJson(jsonData);
  }

  static Future<Reviews> getTVShowReviews(int id) async {
    String BASEURL = tv_show + id.toString() + reviews + api_key_str + api_key;
    var response = await http.get((BASEURL));
    var jsonData = jsonDecode(response.body);
    return Reviews.fromJson(jsonData);
  }

  static Future<SimilarTvShow> getSimilarTVShow(int id) async {
    String BASEURL = tv_show + id.toString() + similar + api_key_str + api_key;
    var response = await http.get((BASEURL));
    var jsonData = jsonDecode(response.body);
    return SimilarTvShow.fromJson(jsonData);
  }

  static Future<SearchMovie> getSearchedMovies(String queryValue) async {
    String BASEURL = search_movie + api_key_str + api_key + query + queryValue;
    var response = await http.get((BASEURL));
    var jsonData = jsonDecode(response.body);
    return SearchMovie.fromJson(jsonData);
  }

  static Future<SearchTvShow> getSearchedTVShow(String queryValue) async {
    String BASEURL = search_tv + api_key_str + api_key + query + queryValue;
    var response = await http.get((BASEURL));
    var jsonData = jsonDecode(response.body);
    return SearchTvShow.fromJson(jsonData);
  }

  static Future<Movies> getPopularMovies() async {
    String BASEURL = movie_popular + api_key_str + api_key;
    var response = await http.get((BASEURL));
    var jsonData = jsonDecode(response.body);
    return Movies.fromJson(jsonData);
  }

  static Future<Movies> getTopRated() async {
    String BASEURL = movie_top_rated + api_key_str + api_key;
    var response = await http.get((BASEURL));
    var jsonData = jsonDecode(response.body);
    return Movies.fromJson(jsonData);
  }

  static Future<Movies> getUpcoming() async {
    String BASEURL = movie_upcoming + api_key_str + api_key;
    var response = await http.get((BASEURL));
    var jsonData = jsonDecode(response.body);
    return Movies.fromJson(jsonData);
  }

  static Future<TVShows> getPopularTVShows() async {
    String BASEURL = tv_popular + api_key_str + api_key;
    var response = await http.get((BASEURL));
    var jsonData = jsonDecode(response.body);
    return TVShows.fromJson(jsonData);
  }

  static Future<TVShows> getAiringTodayTVShows() async {
    String BASEURL = tv_airing_today + api_key_str + api_key;
    var response = await http.get((BASEURL));
    var jsonData = jsonDecode(response.body);
    return TVShows.fromJson(jsonData);
  }

  static Future<TVShows> getOnTVShows() async {
    String BASEURL = on_the_air + api_key_str + api_key;
    var response = await http.get((BASEURL));
    var jsonData = jsonDecode(response.body);
    return TVShows.fromJson(jsonData);
  }

  static Future<TVShows> getTopRatedTVShows() async {
    String BASEURL = tv_top_rated + api_key_str + api_key;
    var response = await http.get((BASEURL));
    var jsonData = jsonDecode(response.body);
    return TVShows.fromJson(jsonData);
  }
}
