// To parse this JSON data, do
//
//     final searchMovie = searchMovieFromJson(jsonString);

import 'dart:convert';

SearchMovie searchMovieFromJson(String str) => SearchMovie.fromJson(json.decode(str));

String searchMovieToJson(SearchMovie data) => json.encode(data.toJson());

class SearchMovie {
  final int page;
  final int totalResults;
  final int totalPages;
  final List<Result> results;

  SearchMovie({
    this.page,
    this.totalResults,
    this.totalPages,
    this.results,
  });

  factory SearchMovie.fromJson(Map<String, dynamic> json) => SearchMovie(
        page: json["page"] == null ? null : json["page"],
        totalResults: json["total_results"] == null ? null : json["total_results"],
        totalPages: json["total_pages"] == null ? null : json["total_pages"],
        results: json["results"] == null ? null : List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "page": page == null ? null : page,
        "total_results": totalResults == null ? null : totalResults,
        "total_pages": totalPages == null ? null : totalPages,
        "results": results == null ? null : List<dynamic>.from(results.map((x) => x.toJson())),
      };
}

class Result {
  final double popularity;
  final int id;
  final bool video;
  final int voteCount;
  final double voteAverage;
  final String title;
  final String releaseDate;
  final OriginalLanguage originalLanguage;
  final String originalTitle;
  final List<int> genreIds;
  final String backdropPath;
  final bool adult;
  final String overview;
  final String posterPath;

  Result({
    this.popularity,
    this.id,
    this.video,
    this.voteCount,
    this.voteAverage,
    this.title,
    this.releaseDate,
    this.originalLanguage,
    this.originalTitle,
    this.genreIds,
    this.backdropPath,
    this.adult,
    this.overview,
    this.posterPath,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        popularity: json["popularity"] == null ? null : json["popularity"].toDouble(),
        id: json["id"] == null ? null : json["id"],
        video: json["video"] == null ? null : json["video"],
        voteCount: json["vote_count"] == null ? null : json["vote_count"],
        voteAverage: json["vote_average"] == null ? null : json["vote_average"].toDouble(),
        title: json["title"] == null ? null : json["title"],
        releaseDate: json["release_date"] == null ? null : json["release_date"],
        originalLanguage: json["original_language"] == null ? null : originalLanguageValues.map[json["original_language"]],
        originalTitle: json["original_title"] == null ? null : json["original_title"],
        genreIds: json["genre_ids"] == null ? null : List<int>.from(json["genre_ids"].map((x) => x)),
        backdropPath: json["backdrop_path"] == null ? null : json["backdrop_path"],
        adult: json["adult"] == null ? null : json["adult"],
        overview: json["overview"] == null ? null : json["overview"],
        posterPath: json["poster_path"] == null ? null : json["poster_path"],
      );

  Map<String, dynamic> toJson() => {
        "popularity": popularity == null ? null : popularity,
        "id": id == null ? null : id,
        "video": video == null ? null : video,
        "vote_count": voteCount == null ? null : voteCount,
        "vote_average": voteAverage == null ? null : voteAverage,
        "title": title == null ? null : title,
        "release_date": releaseDate == null ? null : releaseDate,
        "original_language": originalLanguage == null ? null : originalLanguageValues.reverse[originalLanguage],
        "original_title": originalTitle == null ? null : originalTitle,
        "genre_ids": genreIds == null ? null : List<dynamic>.from(genreIds.map((x) => x)),
        "backdrop_path": backdropPath == null ? null : backdropPath,
        "adult": adult == null ? null : adult,
        "overview": overview == null ? null : overview,
        "poster_path": posterPath == null ? null : posterPath,
      };
}

enum OriginalLanguage { EN, SV }

final originalLanguageValues = EnumValues({"en": OriginalLanguage.EN, "sv": OriginalLanguage.SV});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
