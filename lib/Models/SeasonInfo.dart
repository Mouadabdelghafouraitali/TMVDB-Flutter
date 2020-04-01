// To parse this JSON data, do
//
//     final seasonInfo = seasonInfoFromJson(jsonString);

import 'dart:convert';

SeasonInfo seasonInfoFromJson(String str) => SeasonInfo.fromJson(json.decode(str));

String seasonInfoToJson(SeasonInfo data) => json.encode(data.toJson());

class SeasonInfo {
  String id;
  DateTime airDate;
  List<Episode> episodes;
  String name;
  String overview;
  int seasonInfoId;
  String posterPath;
  int seasonNumber;

  SeasonInfo({
    this.id,
    this.airDate,
    this.episodes,
    this.name,
    this.overview,
    this.seasonInfoId,
    this.posterPath,
    this.seasonNumber,
  });

  factory SeasonInfo.fromJson(Map<String, dynamic> json) => SeasonInfo(
        id: json["_id"] == null ? null : json["_id"],
        airDate: json["air_date"] == null ? null : DateTime.parse(json["air_date"]),
        episodes: json["episodes"] == null ? null : List<Episode>.from(json["episodes"].map((x) => Episode.fromJson(x))),
        name: json["name"] == null ? null : json["name"],
        overview: json["overview"] == null ? null : json["overview"],
        seasonInfoId: json["id"] == null ? null : json["id"],
        posterPath: json["poster_path"] == null ? null : json["poster_path"],
        seasonNumber: json["season_number"] == null ? null : json["season_number"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id == null ? null : id,
        "air_date": airDate == null
            ? null
            : "${airDate.year.toString().padLeft(4, '0')}-${airDate.month.toString().padLeft(2, '0')}-${airDate.day.toString().padLeft(2, '0')}",
        "episodes": episodes == null ? null : List<dynamic>.from(episodes.map((x) => x.toJson())),
        "name": name == null ? null : name,
        "overview": overview == null ? null : overview,
        "id": seasonInfoId == null ? null : seasonInfoId,
        "poster_path": posterPath == null ? null : posterPath,
        "season_number": seasonNumber == null ? null : seasonNumber,
      };
}

class Episode {
  DateTime airDate;
  int episodeNumber;
  int id;
  String name;
  String overview;
  String productionCode;
  int seasonNumber;
  int showId;
  String stillPath;
  double voteAverage;
  int voteCount;
  List<Crew> crew;
  List<GuestStar> guestStars;

  Episode({
    this.airDate,
    this.episodeNumber,
    this.id,
    this.name,
    this.overview,
    this.productionCode,
    this.seasonNumber,
    this.showId,
    this.stillPath,
    this.voteAverage,
    this.voteCount,
    this.crew,
    this.guestStars,
  });

  factory Episode.fromJson(Map<String, dynamic> json) => Episode(
        airDate: json["air_date"] == null ? null : DateTime.parse(json["air_date"]),
        episodeNumber: json["episode_number"] == null ? null : json["episode_number"],
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        overview: json["overview"] == null ? null : json["overview"],
        productionCode: json["production_code"] == null ? null : json["production_code"],
        seasonNumber: json["season_number"] == null ? null : json["season_number"],
        showId: json["show_id"] == null ? null : json["show_id"],
        stillPath: json["still_path"] == null ? null : json["still_path"],
        voteAverage: json["vote_average"] == null ? null : json["vote_average"].toDouble(),
        voteCount: json["vote_count"] == null ? null : json["vote_count"],
        crew: json["crew"] == null ? null : List<Crew>.from(json["crew"].map((x) => Crew.fromJson(x))),
        guestStars: json["guest_stars"] == null ? null : List<GuestStar>.from(json["guest_stars"].map((x) => GuestStar.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "air_date": airDate == null
            ? null
            : "${airDate.year.toString().padLeft(4, '0')}-${airDate.month.toString().padLeft(2, '0')}-${airDate.day.toString().padLeft(2, '0')}",
        "episode_number": episodeNumber == null ? null : episodeNumber,
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "overview": overview == null ? null : overview,
        "production_code": productionCode == null ? null : productionCode,
        "season_number": seasonNumber == null ? null : seasonNumber,
        "show_id": showId == null ? null : showId,
        "still_path": stillPath == null ? null : stillPath,
        "vote_average": voteAverage == null ? null : voteAverage,
        "vote_count": voteCount == null ? null : voteCount,
        "crew": crew == null ? null : List<dynamic>.from(crew.map((x) => x.toJson())),
        "guest_stars": guestStars == null ? null : List<dynamic>.from(guestStars.map((x) => x.toJson())),
      };
}

class Crew {
  int id;
  String creditId;
  String name;
  Department department;
  Job job;
  int gender;
  String profilePath;

  Crew({
    this.id,
    this.creditId,
    this.name,
    this.department,
    this.job,
    this.gender,
    this.profilePath,
  });

  factory Crew.fromJson(Map<String, dynamic> json) => Crew(
        id: json["id"] == null ? null : json["id"],
        creditId: json["credit_id"] == null ? null : json["credit_id"],
        name: json["name"] == null ? null : json["name"],
        department: json["department"] == null ? null : departmentValues.map[json["department"]],
        job: json["job"] == null ? null : jobValues.map[json["job"]],
        gender: json["gender"] == null ? null : json["gender"],
        profilePath: json["profile_path"] == null ? null : json["profile_path"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "credit_id": creditId == null ? null : creditId,
        "name": name == null ? null : name,
        "department": department == null ? null : departmentValues.reverse[department],
        "job": job == null ? null : jobValues.reverse[job],
        "gender": gender == null ? null : gender,
        "profile_path": profilePath == null ? null : profilePath,
      };
}

enum Department { DIRECTING, WRITING, COSTUME_MAKE_UP }

final departmentValues =
    EnumValues({"Costume & Make-Up": Department.COSTUME_MAKE_UP, "Directing": Department.DIRECTING, "Writing": Department.WRITING});

enum Job { DIRECTOR, WRITER, COSTUME_SUPERVISOR }

final jobValues = EnumValues({"Costume Supervisor": Job.COSTUME_SUPERVISOR, "Director": Job.DIRECTOR, "Writer": Job.WRITER});

class GuestStar {
  int id;
  String name;
  String creditId;
  String character;
  int order;
  int gender;
  String profilePath;

  GuestStar({
    this.id,
    this.name,
    this.creditId,
    this.character,
    this.order,
    this.gender,
    this.profilePath,
  });

  factory GuestStar.fromJson(Map<String, dynamic> json) => GuestStar(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        creditId: json["credit_id"] == null ? null : json["credit_id"],
        character: json["character"] == null ? null : json["character"],
        order: json["order"] == null ? null : json["order"],
        gender: json["gender"] == null ? null : json["gender"],
        profilePath: json["profile_path"] == null ? null : json["profile_path"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "credit_id": creditId == null ? null : creditId,
        "character": character == null ? null : character,
        "order": order == null ? null : order,
        "gender": gender == null ? null : gender,
        "profile_path": profilePath == null ? null : profilePath,
      };
}

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
