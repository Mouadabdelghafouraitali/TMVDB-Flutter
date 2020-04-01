// To parse this JSON data, do
//
//     final searchTvShow = searchTvShowFromJson(jsonString);

import 'dart:convert';

SearchTvShow searchTvShowFromJson(String str) => SearchTvShow.fromJson(json.decode(str));

String searchTvShowToJson(SearchTvShow data) => json.encode(data.toJson());

class SearchTvShow {
  int page;
  int totalResults;
  int totalPages;
  List<Result> results;

  SearchTvShow({
    this.page,
    this.totalResults,
    this.totalPages,
    this.results,
  });

  factory SearchTvShow.fromJson(Map<String, dynamic> json) => SearchTvShow(
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
  String originalName;
  List<int> genreIds;
  String name;
  double popularity;
  List<String> originCountry;
  int voteCount;
  String firstAirDate;
  String backdropPath;
  OriginalLanguage originalLanguage;
  int id;
  double voteAverage;
  String overview;
  String posterPath;

  Result({
    this.originalName,
    this.genreIds,
    this.name,
    this.popularity,
    this.originCountry,
    this.voteCount,
    this.firstAirDate,
    this.backdropPath,
    this.originalLanguage,
    this.id,
    this.voteAverage,
    this.overview,
    this.posterPath,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        originalName: json["original_name"] == null ? null : json["original_name"],
        genreIds: json["genre_ids"] == null ? null : List<int>.from(json["genre_ids"].map((x) => x)),
        name: json["name"] == null ? null : json["name"],
        popularity: json["popularity"] == null ? null : json["popularity"].toDouble(),
        originCountry: json["origin_country"] == null ? null : List<String>.from(json["origin_country"].map((x) => x)),
        voteCount: json["vote_count"] == null ? null : json["vote_count"],
        firstAirDate: json["first_air_date"] == null ? null : json["first_air_date"],
        backdropPath: json["backdrop_path"] == null ? null : json["backdrop_path"],
        originalLanguage: json["original_language"] == null ? null : originalLanguageValues.map[json["original_language"]],
        id: json["id"] == null ? null : json["id"],
        voteAverage: json["vote_average"] == null ? null : json["vote_average"].toDouble(),
        overview: json["overview"] == null ? null : json["overview"],
        posterPath: json["poster_path"] == null ? null : json["poster_path"],
      );

  Map<String, dynamic> toJson() => {
        "original_name": originalName == null ? null : originalName,
        "genre_ids": genreIds == null ? null : List<dynamic>.from(genreIds.map((x) => x)),
        "name": name == null ? null : name,
        "popularity": popularity == null ? null : popularity,
        "origin_country": originCountry == null ? null : List<dynamic>.from(originCountry.map((x) => x)),
        "vote_count": voteCount == null ? null : voteCount,
        "first_air_date": firstAirDate == null ? null : firstAirDate,
        "backdrop_path": backdropPath == null ? null : backdropPath,
        "original_language": originalLanguage == null ? null : originalLanguageValues.reverse[originalLanguage],
        "id": id == null ? null : id,
        "vote_average": voteAverage == null ? null : voteAverage,
        "overview": overview == null ? null : overview,
        "poster_path": posterPath == null ? null : posterPath,
      };
}

enum OriginalLanguage { EN, TL, HI, JA }

final originalLanguageValues =
    EnumValues({"en": OriginalLanguage.EN, "hi": OriginalLanguage.HI, "ja": OriginalLanguage.JA, "tl": OriginalLanguage.TL});

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
