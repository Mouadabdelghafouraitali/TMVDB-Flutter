import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:themoviesdb/Models/GenresModel/Genre.dart' as mGenre;
import 'package:themoviesdb/Models/inShortModel/InShortGenreList.dart';
import 'package:themoviesdb/UI/Movie/MovieDetails.dart';
import 'package:themoviesdb/Utils/FutureHelper.dart';
import 'package:themoviesdb/Utils/Helper.dart';

class MoviesByGenre extends StatefulWidget {
  final int id;
  final String name;

  MoviesByGenre({this.id, this.name});

  @override
  _MoviesByGenreState createState() => _MoviesByGenreState();
}

class _MoviesByGenreState extends State<MoviesByGenre> {
  List<InShortGenreList> genreList = [];
  List<InShortGenreList> inShortGenreList = [];
  bool isGenresLoaded = false;

  @override
  void initState() {
    FutureHelper.getListGenres().then((genreList) {
      for (var genre in genreList.genres) {
        inShortGenreList.add(InShortGenreList(id: genre.id, name: genre.name));
      }
      if (genreList.genres.length > 0) {
        isGenresLoaded = true;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _getToolbar(context, widget.name),
      body: _getContent(widget.id),
    );
  }

  _getToolbar(BuildContext context, String title) {
    return AppBar(
        title: Text(title, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: false,
        backgroundColor: Color(0xFF080E10),
        elevation: 0.0,
        leading: IconButton(icon: Icon(Icons.arrow_back_ios, color: Color(0xFF01d277)), onPressed: () => Navigator.pop(context)));
  }

  _getContent(int id) {
    return Container(
        child: FutureBuilder<mGenre.Genre>(
      future: FutureHelper.getGenres(id),
      builder: (BuildContext context, AsyncSnapshot<mGenre.Genre> snapshot) {
        if (snapshot.hasData && snapshot.data.results != null) {
          return ListView.builder(
              itemBuilder: (context, index) {
                return _item(snapshot, index);
              },
              physics: BouncingScrollPhysics(),
              itemCount: snapshot.data.results.length);
        } else {
          return Center(
            child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  backgroundColor: Color(0xFF01d277),
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                  strokeWidth: 2.0,
                )),
          );
        }
      },
    ));
  }

  _item(AsyncSnapshot<mGenre.Genre> snapshot, int index) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return MovieDetails(
                id: snapshot.data.results[index].id,
                title: Helper.getExactTitle(snapshot, index),
                overview: Helper.getExactOverview(snapshot, index),
                posterPath: Helper.getExactPoster(snapshot, index),
                backdropPath: Helper.getExactCover(snapshot, index),
                voteAverage: Helper.getExactVoteAverage(snapshot, index),
                heroId: '${snapshot.data.results[index].id}genres');
          }));
        },
        child: Hero(
          tag: '${snapshot.data.results[index].id}genres',
          child: Card(
            elevation: 0.3,
            child: Row(
              children: <Widget>[
                SizedBox(
                  height: 190.0,
                  width: 140.0,
                  child: Stack(
                    children: <Widget>[
                      Helper.loadImage(Helper.getExactPoster(snapshot, index), 190.0, MediaQuery.of(context).size.width, context, BoxFit.cover),
                      Align(
                        alignment: Alignment.topRight,
                        child: SizedBox(
                            width: 20,
                            height: 30,
                            child: Container(
                              alignment: Alignment.topRight,
                              width: 20,
                              color: MaterialColor(0xFF01F277, Helper.color),
                              child: Center(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      Helper.getExactRatingValue(snapshot, index),
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                                    ),
                                    Helper.getExactRating(Helper.getExactRatingValue(snapshot, index))
                                  ],
                                ),
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 4),
                _getDetails(snapshot, index)
              ],
            ),
          ),
        ),
      ),
    );
  }

  _getDetails(AsyncSnapshot<mGenre.Genre> snapshot, int index) {
    return Expanded(
      child: Container(
        width: 200.0,
        height: 190.0,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[_subDetails(snapshot, index), _moreInfo()]),
      ),
    );
  }

  _subDetails(AsyncSnapshot<mGenre.Genre> snapshot, int index) {
    return Expanded(
      child: Container(
        height: 150.0,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Text(Helper.getExactTitle(snapshot, index),
                textAlign: TextAlign.left,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.bold)),
          ),
          Text(Helper.getExactGenres(snapshot.data.results[index].genreIds, index, inShortGenreList),
              textAlign: TextAlign.left,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.black, fontSize: 12.0, fontWeight: FontWeight.normal)),
          Divider(color: Colors.black, thickness: 0.2),
          SizedBox(height: 2),
          Expanded(
            child: Text(snapshot.data.results[index].overview,
                textAlign: TextAlign.left,
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.black, fontSize: 12.0, fontWeight: FontWeight.normal)),
          ),
        ]),
      ),
    );
  }

  _moreInfo() {
    return Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Divider(color: Colors.black, thickness: 0.2),
            Padding(
              padding: const EdgeInsets.only(top: 0.0, bottom: 6.0),
              child: Center(
                child: Text('More Info',
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.black, fontSize: 12.0, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ));
  }
}
