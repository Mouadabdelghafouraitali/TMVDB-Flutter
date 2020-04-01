// To parse this JSON data, do
//
//     final byPerson = byPersonFromJson(jsonString);

import 'dart:convert';

ByPerson byPersonFromJson(String str) => ByPerson.fromJson(json.decode(str));

String byPersonToJson(ByPerson data) => json.encode(data.toJson());

class ByPerson {
  List<Cast> cast;
  List<Cast> crew;
  int id;

  ByPerson({
    this.cast,
    this.crew,
    this.id,
  });

  factory ByPerson.fromJson(Map<String, dynamic> json) =>
      ByPerson(
        cast: json["cast"] == null ? null : List<Cast>.from(json["cast"].map((x) => Cast.fromJson(x))),
        crew: json["crew"] == null ? null : List<Cast>.from(json["crew"].map((x) => Cast.fromJson(x))),
        id: json["id"] == null ? null : json["id"],
      );

  Map<String, dynamic> toJson() =>
      {
        "cast": cast == null ? null : List<dynamic>.from(cast.map((x) => x.toJson())),
        "crew": crew == null ? null : List<dynamic>.from(crew.map((x) => x.toJson())),
        "id": id == null ? null : id,
      };
}

class Cast {
  int id;
  String character;
  String originalTitle;
  String overview;
  int voteCount;
  bool video;
  MediaType mediaType;
  String posterPath;
  String backdropPath;
  double popularity;
  String title;
  OriginalLanguage originalLanguage;
  List<int> genreIds;
  double voteAverage;
  bool adult;
  String releaseDate;
  String creditId;
  int episodeCount;
  List<OriginCountry> originCountry;
  String originalName;
  String name;
  String firstAirDate;
  Department department;
  Job job;

  Cast({
    this.id,
    this.character,
    this.originalTitle,
    this.overview,
    this.voteCount,
    this.video,
    this.mediaType,
    this.posterPath,
    this.backdropPath,
    this.popularity,
    this.title,
    this.originalLanguage,
    this.genreIds,
    this.voteAverage,
    this.adult,
    this.releaseDate,
    this.creditId,
    this.episodeCount,
    this.originCountry,
    this.originalName,
    this.name,
    this.firstAirDate,
    this.department,
    this.job,
  });

  factory Cast.fromJson(Map<String, dynamic> json) =>
      Cast(
        id: json["id"] == null ? null : json["id"],
        character: json["character"] == null ? null : json["character"],
        originalTitle: json["original_title"] == null ? null : json["original_title"],
        overview: json["overview"] == null ? null : json["overview"],
        voteCount: json["vote_count"] == null ? null : json["vote_count"],
        video: json["video"] == null ? null : json["video"],
        mediaType: json["media_type"] == null ? null : mediaTypeValues.map[json["media_type"]],
        posterPath: json["poster_path"] == null ? null : json["poster_path"],
        backdropPath: json["backdrop_path"] == null ? null : json["backdrop_path"],
        popularity: json["popularity"] == null ? null : json["popularity"].toDouble(),
        title: json["title"] == null ? null : json["title"],
        originalLanguage: json["original_language"] == null ? null : originalLanguageValues.map[json["original_language"]],
        genreIds: json["genre_ids"] == null ? null : List<int>.from(json["genre_ids"].map((x) => x)),
        voteAverage: json["vote_average"] == null ? null : json["vote_average"].toDouble(),
        adult: json["adult"] == null ? null : json["adult"],
        releaseDate: json["release_date"] == null ? null : json["release_date"],
        creditId: json["credit_id"] == null ? null : json["credit_id"],
        episodeCount: json["episode_count"] == null ? null : json["episode_count"],
        originCountry: json["origin_country"] == null ? null : List<OriginCountry>.from(
            json["origin_country"].map((x) => originCountryValues.map[x])),
        originalName: json["original_name"] == null ? null : json["original_name"],
        name: json["name"] == null ? null : json["name"],
        firstAirDate: json["first_air_date"] == null ? null : json["first_air_date"],
        department: json["department"] == null ? null : departmentValues.map[json["department"]],
        job: json["job"] == null ? null : jobValues.map[json["job"]],
      );

  Map<String, dynamic> toJson() =>
      {
        "id": id == null ? null : id,
        "character": character == null ? null : character,
        "original_title": originalTitle == null ? null : originalTitle,
        "overview": overview == null ? null : overview,
        "vote_count": voteCount == null ? null : voteCount,
        "video": video == null ? null : video,
        "media_type": mediaType == null ? null : mediaTypeValues.reverse[mediaType],
        "poster_path": posterPath == null ? null : posterPath,
        "backdrop_path": backdropPath == null ? null : backdropPath,
        "popularity": popularity == null ? null : popularity,
        "title": title == null ? null : title,
        "original_language": originalLanguage == null ? null : originalLanguageValues.reverse[originalLanguage],
        "genre_ids": genreIds == null ? null : List<dynamic>.from(genreIds.map((x) => x)),
        "vote_average": voteAverage == null ? null : voteAverage,
        "adult": adult == null ? null : adult,
        "release_date": releaseDate == null ? null : releaseDate,
        "credit_id": creditId == null ? null : creditId,
        "episode_count": episodeCount == null ? null : episodeCount,
        "origin_country": originCountry == null ? null : List<dynamic>.from(originCountry.map((x) => originCountryValues.reverse[x])),
        "original_name": originalName == null ? null : originalName,
        "name": name == null ? null : name,
        "first_air_date": firstAirDate == null ? null : firstAirDate,
        "department": department == null ? null : departmentValues.reverse[department],
        "job": job == null ? null : jobValues.reverse[job],
      };
}

enum Department { CREW, DIRECTING, EDITING, PRODUCTION, WRITING }

final departmentValues = EnumValues({
  "Crew": Department.CREW,
  "Directing": Department.DIRECTING,
  "Editing": Department.EDITING,
  "Production": Department.PRODUCTION,
  "Writing": Department.WRITING
});

enum Job { CINEMATOGRAPHY, DIRECTOR, EDITOR, EXECUTIVE_PRODUCER, PRODUCER, SCREENPLAY, WRITER, STORY }

final jobValues = EnumValues({
  "Cinematography": Job.CINEMATOGRAPHY,
  "Director": Job.DIRECTOR,
  "Editor": Job.EDITOR,
  "Executive Producer": Job.EXECUTIVE_PRODUCER,
  "Producer": Job.PRODUCER,
  "Screenplay": Job.SCREENPLAY,
  "Story": Job.STORY,
  "Writer": Job.WRITER
});

enum MediaType { MOVIE, TV }

final mediaTypeValues = EnumValues({
  "movie": MediaType.MOVIE,
  "tv": MediaType.TV
});

enum OriginCountry { US }

final originCountryValues = EnumValues({
  "US": OriginCountry.US
});

enum OriginalLanguage { EN }

final originalLanguageValues = EnumValues({
  "en": OriginalLanguage.EN
});

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
