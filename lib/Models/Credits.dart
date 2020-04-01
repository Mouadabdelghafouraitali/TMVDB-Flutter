// To parse this JSON data, do
//
//     final credits = creditsFromJson(jsonString);

import 'dart:convert';

Credits creditsFromJson(String str) => Credits.fromJson(json.decode(str));

String creditsToJson(Credits data) => json.encode(data.toJson());

class Credits {
  int id;
  List<Cast> cast;
  List<Crew> crew;

  Credits({
    this.id,
    this.cast,
    this.crew,
  });

  factory Credits.fromJson(Map<String, dynamic> json) => Credits(
        id: json["id"] == null ? null : json["id"],
        cast: json["cast"] == null ? null : List<Cast>.from(json["cast"].map((x) => Cast.fromJson(x))),
        crew: json["crew"] == null ? null : List<Crew>.from(json["crew"].map((x) => Crew.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "cast": cast == null ? null : List<dynamic>.from(cast.map((x) => x.toJson())),
        "crew": crew == null ? null : List<dynamic>.from(crew.map((x) => x.toJson())),
      };
}

class Cast {
  int castId;
  String character;
  String creditId;
  int gender;
  int id;
  String name;
  int order;
  String profilePath;

  Cast({
    this.castId,
    this.character,
    this.creditId,
    this.gender,
    this.id,
    this.name,
    this.order,
    this.profilePath,
  });

  factory Cast.fromJson(Map<String, dynamic> json) => Cast(
        castId: json["cast_id"] == null ? null : json["cast_id"],
        character: json["character"] == null ? null : json["character"],
        creditId: json["credit_id"] == null ? null : json["credit_id"],
        gender: json["gender"] == null ? null : json["gender"],
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        order: json["order"] == null ? null : json["order"],
        profilePath: json["profile_path"] == null ? null : json["profile_path"],
      );

  Map<String, dynamic> toJson() => {
        "cast_id": castId == null ? null : castId,
        "character": character == null ? null : character,
        "credit_id": creditId == null ? null : creditId,
        "gender": gender == null ? null : gender,
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "order": order == null ? null : order,
        "profile_path": profilePath == null ? null : profilePath,
      };
}

class Crew {
  String creditId;
  String department;
  int gender;
  int id;
  String job;
  String name;
  String profilePath;

  Crew({
    this.creditId,
    this.department,
    this.gender,
    this.id,
    this.job,
    this.name,
    this.profilePath,
  });

  factory Crew.fromJson(Map<String, dynamic> json) => Crew(
        creditId: json["credit_id"] == null ? null : json["credit_id"],
        department: json["department"] == null ? null : json["department"],
        gender: json["gender"] == null ? null : json["gender"],
        id: json["id"] == null ? null : json["id"],
        job: json["job"] == null ? null : json["job"],
        name: json["name"] == null ? null : json["name"],
        profilePath: json["profile_path"] == null ? null : json["profile_path"],
      );

  Map<String, dynamic> toJson() => {
        "credit_id": creditId == null ? null : creditId,
        "department": department == null ? null : department,
        "gender": gender == null ? null : gender,
        "id": id == null ? null : id,
        "job": job == null ? null : job,
        "name": name == null ? null : name,
        "profile_path": profilePath == null ? null : profilePath,
      };
}
