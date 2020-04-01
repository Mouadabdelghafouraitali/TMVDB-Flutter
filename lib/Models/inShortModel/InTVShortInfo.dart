class InTVShortInfo {
  String originalName;
  int id;
  String name;
  int voteCount;
  double voteAverage;
  DateTime firstAirDate;
  String posterPath;
  List<int> genreIds;
  String backdropPath;
  String overview;
  List<String> originCountry;
  double popularity;
  String mediaType;

  InTVShortInfo(this.originalName, this.name, this.popularity, this.voteCount, this.firstAirDate, this.backdropPath, this.id, this.voteAverage,
      this.overview, this.posterPath);
}
