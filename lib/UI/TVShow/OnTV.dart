import 'package:flutter/material.dart';
import 'package:themoviesdb/Models/TVShows.dart';
import 'package:themoviesdb/Models/inShortModel/InShortGenreList.dart';
import 'package:themoviesdb/Utils/FutureHelper.dart';
import 'package:themoviesdb/Utils/Helper.dart';
import 'package:themoviesdb/Utils/WidgetHelper.dart';

import 'TVShowDetails.dart';

class OnTV extends StatefulWidget {
  @override
  _OnTVState createState() => _OnTVState();
}

class _OnTVState extends State<OnTV> {
  List<InShortGenreList> inShortGenreList = [];

  @override
  void initState() {
    FutureHelper.getListGenres().then((genreList) {
      for (var genre in genreList.genres) {
        inShortGenreList.add(InShortGenreList(id: genre.id, name: genre.name));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _getContent(), backgroundColor: Colors.black);
  }

  _getContent() {
    return Container(
        child: FutureBuilder<TVShows>(
      future: FutureHelper.getOnTVShows(),
      builder: (BuildContext context, AsyncSnapshot<TVShows> snapshot) {
        if (snapshot.hasData && snapshot.data.results != null) {
          if (snapshot.data.results.length > 0) {
            return ListView.builder(
                itemBuilder: (context, index) {
                  return _itemTVShow(snapshot, index);
                },
                physics: BouncingScrollPhysics(),
                itemCount: snapshot.data.results.length);
          } else
            return WidgetHelper.getImgState('Ops! no result found', 'assets/images/no_result.png');
        } else {
          return Center(
            child: WidgetHelper.getCircularProgress(40),
          );
        }
      },
    ));
  }

  _itemTVShow(AsyncSnapshot<TVShows> snapshot, int index) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return TVShowDetails(
                id: snapshot.data.results[index].id,
                title: Helper.getExactName(snapshot, index),
                overview: Helper.getExactOverview(snapshot, index),
                posterPath: Helper.getExactPoster(snapshot, index),
                backdropPath: Helper.getExactCover(snapshot, index),
                voteAverage: Helper.getExactVoteAverage(snapshot, index),
                heroId: '${snapshot.data.results[index].id}ontv');
          }));
        },
        child: Hero(
          tag: '${snapshot.data.results[index].id}ontv',
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
                _getTVShowDetails(snapshot, index)
              ],
            ),
          ),
        ),
      ),
    );
  }

  _getTVShowDetails(AsyncSnapshot<TVShows> snapshot, int index) {
    return Expanded(
      child: Container(
        width: 200.0,
        height: 190.0,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[_subTVShowDetails(snapshot, index), _moreInfo()]),
      ),
    );
  }

  _subTVShowDetails(AsyncSnapshot<TVShows> snapshot, int index) {
    return Expanded(
      child: Container(
        height: 150.0,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Text(Helper.getExactName(snapshot, index),
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
            child: Text(Helper.getExactOverview(snapshot, index),
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
