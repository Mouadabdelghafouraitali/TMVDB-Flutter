// To parse this JSON data, do
//
//     final similar = similarFromJson(jsonString);

import 'dart:convert';

Similar similarFromJson(String str) => Similar.fromJson(json.decode(str));

String similarToJson(Similar data) => json.encode(data.toJson());

class Similar {
  int page;
  List<Result> results;
  int totalPages;
  int totalResults;

  Similar({
    this.page,
    this.results,
    this.totalPages,
    this.totalResults,
  });

  factory Similar.fromJson(Map<String, dynamic> json) => Similar(
        page: json["page"] == null ? null : json["page"],
        results: json["results"] == null ? null : List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
        totalPages: json["total_pages"] == null ? null : json["total_pages"],
        totalResults: json["total_results"] == null ? null : json["total_results"],
      );

  Map<String, dynamic> toJson() => {
        "page": page == null ? null : page,
        "results": results == null ? null : List<dynamic>.from(results.map((x) => x.toJson())),
        "total_pages": totalPages == null ? null : totalPages,
        "total_results": totalResults == null ? null : totalResults,
      };
}

class Result {
  int id;
  bool video;
  int voteCount;
  double voteAverage;
  String title;
  DateTime releaseDate;
  OriginalLanguage originalLanguage;
  String originalTitle;
  List<int> genreIds;
  String backdropPath;
  bool adult;
  String overview;
  String posterPath;
  double popularity;

  Result({
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
    this.popularity,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"] == null ? null : json["id"],
        video: json["video"] == null ? null : json["video"],
        voteCount: json["vote_count"] == null ? null : json["vote_count"],
        voteAverage: json["vote_average"] == null ? null : json["vote_average"].toDouble(),
        title: json["title"] == null ? null : json["title"],
        releaseDate: json["release_date"] == null ? null : DateTime.parse(json["release_date"]),
        originalLanguage: json["original_language"] == null ? null : originalLanguageValues.map[json["original_language"]],
        originalTitle: json["original_title"] == null ? null : json["original_title"],
        genreIds: json["genre_ids"] == null ? null : List<int>.from(json["genre_ids"].map((x) => x)),
        backdropPath: json["backdrop_path"] == null ? null : json["backdrop_path"],
        adult: json["adult"] == null ? null : json["adult"],
        overview: json["overview"] == null ? null : json["overview"],
        posterPath: json["poster_path"] == null ? null : json["poster_path"],
        popularity: json["popularity"] == null ? null : json["popularity"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "video": video == null ? null : video,
        "vote_count": voteCount == null ? null : voteCount,
        "vote_average": voteAverage == null ? null : voteAverage,
        "title": title == null ? null : title,
        "release_date": releaseDate == null
            ? null
            : "${releaseDate.year.toString().padLeft(4, '0')}-${releaseDate.month.toString().padLeft(2, '0')}-${releaseDate.day.toString().padLeft(2, '0')}",
        "original_language": originalLanguage == null ? null : originalLanguageValues.reverse[originalLanguage],
        "original_title": originalTitle == null ? null : originalTitle,
        "genre_ids": genreIds == null ? null : List<dynamic>.from(genreIds.map((x) => x)),
        "backdrop_path": backdropPath == null ? null : backdropPath,
        "adult": adult == null ? null : adult,
        "overview": overview == null ? null : overview,
        "poster_path": posterPath == null ? null : posterPath,
        "popularity": popularity == null ? null : popularity,
      };
}

enum OriginalLanguage { EN }

final originalLanguageValues = EnumValues({"en": OriginalLanguage.EN});

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
