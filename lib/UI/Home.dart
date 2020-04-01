import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:themoviesdb/Models/Movies.dart';
import 'package:themoviesdb/Models/OnTheAir.dart';
import 'package:themoviesdb/Models/TVShow.dart';
import 'package:themoviesdb/Models/Trending.dart';
import 'package:themoviesdb/UI/SearchList.dart';
import 'package:themoviesdb/Utils/FutureHelper.dart';
import 'package:themoviesdb/Utils/Helper.dart';
import 'package:themoviesdb/Utils/MyConnectivity.dart';
import 'package:themoviesdb/Utils/WidgetHelper.dart';

import 'Movie/MovieDetails.dart';
import 'TVShow/TVShowDetails.dart';
import 'navigationDrawer.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map _source = {ConnectivityResult.none: false};
  MyConnectivity _connectivity = MyConnectivity.instance;
  final TextEditingController _filter = new TextEditingController();
  bool isDataLoadedBefore = false;
  TextEditingController searchController = new TextEditingController();
  String searchString = '';
  String lastSearchString = '';
  bool showSearch = false;

  @override
  void initState() {
    super.initState();
    _connectivity.initialise();
    _connectivity.myStream.listen((source) {
      setState(() => _source = source);
    });
  }

  @override
  void dispose() {
    _connectivity.disposeStream();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        drawer: navigationDrawer(context),
        appBar: AppBar(
          centerTitle: false,
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Image(
                width: 35,
                height: 35,
                image: ExactAssetImage('assets/images/icon_logo.png'),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                'THE MOVIE DB',
                style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
              )
            ],
          ),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return SearchList();
                  }));
                })
          ],
        ),
        body: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _fetchDataFromApi(),
                ),
              ),
            ),
          ],
        ));
  }

  Widget _fetchDataFromApi() {
    switch (_source.keys.toList()[0]) {
      case ConnectivityResult.none:
        if (!isDataLoadedBefore)
          return Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              child: Align(
                  alignment: Alignment.center, child: WidgetHelper.getImgState('Waiting for internet!', 'assets/images/waiting_for_internet.png')));
        else
          return _fetchData();
        break;
      case ConnectivityResult.mobile:
        isDataLoadedBefore = true;
        return _fetchData();
        break;
      case ConnectivityResult.wifi:
        isDataLoadedBefore = true;
        return _fetchData();
    }
  }

  _fetchData() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[_getOnTV(), _getInTheaters(), _getTrendingToday(), _getTrendingWeek()],
    );
  }

  _itemTop(String originalName, String cover, String postImg, int id, String type, String releaseDate) {
    return Container(
      width: double.infinity,
      height: 180,
      child: Stack(
        children: <Widget>[
          Stack(children: <Widget>[
            Container(child: Helper.loadImage(cover, 180, MediaQuery.of(context).size.width, context, BoxFit.cover), width: double.infinity),
            _getBackgroundGradient(130)
          ]),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(width: 60, height: 100, child: Helper.loadImage(postImg, 100, MediaQuery.of(context).size.width, context, BoxFit.cover)),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          originalName,
                          maxLines: 2,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      FutureBuilder<TVShow>(
                        future: FutureHelper.getNextEpisodeInfo(id),
                        builder: (BuildContext context, AsyncSnapshot<TVShow> snapshot) {
                          if (type != 'TVShow') {
                            return Text('Released at : ' + releaseDate,
                                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 12, color: Colors.white));
                          } else {
                            if (snapshot.hasData) {
                              return Text(Helper.getNextEpisode(snapshot.data.nextEpisodeToAir, 'NIA', true),
                                  style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14, color: Colors.white));
                            } else {
                              return Text('Loading...', style: TextStyle(fontWeight: FontWeight.normal, fontSize: 10, color: Colors.white));
                            }
                          }
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _itemBottom(AsyncSnapshot snapshot, int index, String originalName, String cover, int id, String type, String releaseDate) {
    return Expanded(
        child: Hero(
      tag: '${snapshot.data.results[index].id}itembottom',
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: <Widget>[
          GestureDetector(
            child: Stack(children: <Widget>[
              Container(height: 100, child: Helper.loadImage(cover, 100, MediaQuery.of(context).size.width, context, BoxFit.cover)),
              _getBackgroundGradient(55)
            ]),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                if (type != "TVShow")
                  return MovieDetails(
                      id: snapshot.data.results[index].id,
                      title: Helper.getExactTitleName(snapshot, index),
                      overview: Helper.getExactOverview(snapshot, index),
                      posterPath: Helper.getExactPoster(snapshot, index),
                      backdropPath: Helper.getExactCover(snapshot, index),
                      voteAverage: Helper.getExactVoteAverage(snapshot, index),
                      heroId: '${snapshot.data.results[index].id}itembottom');
                else
                  return TVShowDetails(
                      id: snapshot.data.results[index].id,
                      title: Helper.getExactName(snapshot, index),
                      overview: Helper.getExactOverview(snapshot, index),
                      posterPath: Helper.getExactPoster(snapshot, index),
                      backdropPath: Helper.getExactCover(snapshot, index),
                      voteAverage: Helper.getExactVoteAverage(snapshot, index),
                      heroId: '${snapshot.data.results[index].id}itembottom');
                ;
              }));
            },
          ),
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(originalName,
                    maxLines: 2, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white), textAlign: TextAlign.start),
                SizedBox(height: 2),
                FutureBuilder<TVShow>(
                  future: FutureHelper.getNextEpisodeInfo(id),
                  builder: (BuildContext context, AsyncSnapshot<TVShow> snapshot) {
                    if (type != 'TVShow') {
                      return Text(
                        'Released at : ' + releaseDate,
                        style: TextStyle(fontWeight: FontWeight.normal, fontSize: 10, color: Colors.white),
                        textAlign: TextAlign.left,
                      );
                    } else {
                      if (snapshot.hasData) {
                        return Text(
                          Helper.getNextEpisode(snapshot.data.nextEpisodeToAir, 'NIV', true),
                          style: TextStyle(fontWeight: FontWeight.normal, fontSize: 10, color: Colors.white),
                          textAlign: TextAlign.left,
                        );
                      } else {
                        return Text(
                          'Loading...',
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 10,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.left,
                        );
                      }
                    }
                  },
                )
              ],
            ),
          ),
        ],
      ),
    ));
  }

  _getOnTV() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
      Padding(
        padding: const EdgeInsets.only(left: 4.0),
        child: Text(
          '• On TV',
          style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      FutureBuilder<OnTheAir>(
        future: FutureHelper.getOnTheAir(),
        builder: (BuildContext context, AsyncSnapshot<OnTheAir> snapshot) {
          if (snapshot.hasData) {
            return ClipRRect(
              child: Card(
                shape: BeveledRectangleBorder(borderRadius: Helper.getExactRadiusValue(0.0)),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                elevation: 0.3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Hero(
                      tag: '${snapshot.data.results[0].id}getOnTV',
                      child: GestureDetector(
                        child: _itemTop(Helper.getExactName(snapshot, 0), Helper.getExactCover(snapshot, 0), Helper.getExactPoster(snapshot, 0),
                            snapshot.data.results[0].id, 'TVShow', ''),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return TVShowDetails(
                                id: snapshot.data.results[0].id,
                                title: Helper.getExactName(snapshot, 0),
                                overview: Helper.getExactOverview(snapshot, 0),
                                posterPath: Helper.getExactPoster(snapshot, 0),
                                backdropPath: Helper.getExactCover(snapshot, 0),
                                voteAverage: Helper.getExactVoteAverage(snapshot, 0),
                                heroId: '${snapshot.data.results[0].id}getOnTV');
                          }));
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        _itemBottom(snapshot, 1, Helper.getExactName(snapshot, 1), Helper.getExactCover(snapshot, 1), snapshot.data.results[1].id,
                            'TVShow', ''),
                        _itemBottom(snapshot, 2, Helper.getExactName(snapshot, 2), Helper.getExactCover(snapshot, 2), snapshot.data.results[2].id,
                            'TVShow', ''),
                      ],
                    )
                  ],
                ),
              ),
            );
          } else
            return WidgetHelper.getCircularProgress(280.0);
        },
      )
    ]);
  }

  _getInTheaters() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
      Padding(
        padding: const EdgeInsets.only(left: 4.0, top: 16.0),
        child: Text(
          '• In Theaters',
          style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      FutureBuilder<Movies>(
        future: FutureHelper.getOnPlayingNow(),
        builder: (BuildContext context, AsyncSnapshot<Movies> snapshot) {
          if (snapshot.hasData) {
            return ClipRRect(
              child: Card(
                shape: BeveledRectangleBorder(borderRadius: Helper.getExactRadiusValue(0.0)),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                elevation: 0.3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        _itemBottom(snapshot, 1, Helper.getExactTitle(snapshot, 1), Helper.getExactCover(snapshot, 1), snapshot.data.results[1].id,
                            'Movies', Helper.getExactDate(snapshot, 1)),
                        _itemBottom(snapshot, 2, Helper.getExactTitle(snapshot, 2), Helper.getExactCover(snapshot, 2), snapshot.data.results[2].id,
                            'Movies', Helper.getExactDate(snapshot, 2)),
                      ],
                    ),
                    Hero(
                      tag: '${snapshot.data.results[0].id}getInTheaters',
                      child: GestureDetector(
                        child: _itemTop(Helper.getExactTitle(snapshot, 0), Helper.getExactCover(snapshot, 0), Helper.getExactPoster(snapshot, 0),
                            snapshot.data.results[0].id, 'Movies', Helper.getExactDate(snapshot, 0)),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return MovieDetails(
                                id: snapshot.data.results[0].id,
                                title: Helper.getExactTitleName(snapshot, 0),
                                overview: Helper.getExactOverview(snapshot, 0),
                                posterPath: Helper.getExactPoster(snapshot, 0),
                                backdropPath: Helper.getExactCover(snapshot, 0),
                                voteAverage: Helper.getExactVoteAverage(snapshot, 0),
                                heroId: '${snapshot.data.results[0].id}getInTheaters');
                          }));
                        },
                      ),
                    )
                  ],
                ),
              ),
            );
          } else
            return WidgetHelper.getCircularProgress(280.0);
        },
      ),
    ]);
  }

  _getTrendingToday() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
      Padding(
        padding: const EdgeInsets.only(left: 4.0, top: 16.0, bottom: 16.0),
        child: Text(
          '• Trending Today',
          style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      Container(
          height: 190,
          child: FutureBuilder<Trending>(
            future: FutureHelper.getTrendingToday(),
            builder: (BuildContext context, AsyncSnapshot<Trending> snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data.results.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        child: Container(
                            width: 100.0,
                            child: Hero(
                              tag: '${snapshot.data.results[index].id}trendyingtoday',
                              child: ClipRRect(
                                child: Card(
                                    shape: BeveledRectangleBorder(borderRadius: Helper.getExactRadiusValue(1.5)),
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    elevation: 0.3,
                                    color: Colors.white,
                                    child: Column(
                                      children: <Widget>[
                                        Expanded(
                                            child: Column(
                                          children: <Widget>[
                                            SizedBox(
                                              height: 140.0,
                                              width: 100.0,
                                              child: Stack(
                                                children: <Widget>[
                                                  Helper.loadImage(Helper.getExactPoster(snapshot, index), 140.0, MediaQuery.of(context).size.width,
                                                      context, BoxFit.cover),
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
                                            _itemBottomTrending(snapshot, index),
                                          ],
                                        )),
                                      ],
                                    )),
                              ),
                            )),
                        onTap: () {
                          if (snapshot.data.results[index].mediaType == MediaType.MOVIE) {
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return MovieDetails(
                                  id: snapshot.data.results[index].id,
                                  title: Helper.getExactTitleName(snapshot, index),
                                  overview: Helper.getExactOverview(snapshot, index),
                                  posterPath: Helper.getExactPoster(snapshot, index),
                                  backdropPath: Helper.getExactCover(snapshot, index),
                                  voteAverage: Helper.getExactVoteAverage(snapshot, index),
                                  heroId: '${snapshot.data.results[index].id}trendyingtoday');
                            }));
                          } else {
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return TVShowDetails(
                                  id: snapshot.data.results[index].id,
                                  title: Helper.getExactTitleName(snapshot, index),
                                  overview: Helper.getExactOverview(snapshot, index),
                                  posterPath: Helper.getExactPoster(snapshot, index),
                                  backdropPath: Helper.getExactCover(snapshot, index),
                                  voteAverage: Helper.getExactVoteAverage(snapshot, index),
                                  heroId: '${snapshot.data.results[index].id}trendyingtoday');
                            }));
                          }
                        },
                      );
                    });
              } else {
                return WidgetHelper.getCircularProgress(190.0);
              }
            },
          ))
    ]);
  }

  _getTrendingWeek() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
      Padding(
        padding: const EdgeInsets.only(left: 4.0, top: 16.0, bottom: 16.0),
        child: Text(
          '• Trending For The Week',
          style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      Container(
          height: 190,
          child: FutureBuilder<Trending>(
            future: FutureHelper.getTrendingWeek(),
            builder: (BuildContext context, AsyncSnapshot<Trending> snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data.results.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        child: Container(
                            width: 100.0,
                            child: Hero(
                              tag: '${snapshot.data.results[index].id}trendyingweek',
                              child: ClipRRect(
                                child: Card(
                                    shape: BeveledRectangleBorder(borderRadius: Helper.getExactRadiusValue(1.5)),
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    elevation: 0.3,
                                    color: Colors.white,
                                    child: Column(
                                      children: <Widget>[
                                        Expanded(
                                            child: Column(
                                          children: <Widget>[
                                            SizedBox(
                                              height: 140.0,
                                              width: 100.0,
                                              child: Stack(
                                                children: <Widget>[
                                                  Helper.loadImage(Helper.getExactPoster(snapshot, index), 140.0, MediaQuery.of(context).size.width,
                                                      context, BoxFit.cover),
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
                                            _itemBottomTrending(snapshot, index),
                                          ],
                                        )),
                                      ],
                                    )),
                              ),
                            )),
                        onTap: () {
                          if (snapshot.data.results[index].mediaType == MediaType.MOVIE) {
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return MovieDetails(
                                  id: snapshot.data.results[index].id,
                                  title: Helper.getExactTitleName(snapshot, index),
                                  overview: Helper.getExactOverview(snapshot, index),
                                  posterPath: Helper.getExactPoster(snapshot, index),
                                  backdropPath: Helper.getExactCover(snapshot, index),
                                  voteAverage: Helper.getExactVoteAverage(snapshot, index),
                                  heroId: '${snapshot.data.results[index].id}trendyingweek');
                            }));
                          } else {
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return TVShowDetails(
                                  id: snapshot.data.results[index].id,
                                  title: Helper.getExactTitleName(snapshot, index),
                                  overview: Helper.getExactOverview(snapshot, index),
                                  posterPath: Helper.getExactPoster(snapshot, index),
                                  backdropPath: Helper.getExactCover(snapshot, index),
                                  voteAverage: Helper.getExactVoteAverage(snapshot, index),
                                  heroId: '${snapshot.data.results[index].id}trendyingweek');
                            }));
                          }
                        },
                      );
                    });
              } else {
                return WidgetHelper.getCircularProgress(190.0);
              }
            },
          ))
    ]);
  }

  _getBackgroundGradient(double top) {
    return Container(
      margin: new EdgeInsets.only(top: top),
      height: top - 10,
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
          colors: <Color>[new Color(0x00000000), new Color(0xFF000000)],
          stops: [0.0, 0.9],
          begin: const FractionalOffset(0.0, 0.0),
          end: const FractionalOffset(0.0, 1.0),
        ),
      ),
    );
  }

  _itemBottomTrending(AsyncSnapshot<Trending> snapshot, int index) {
    return Expanded(
      child: Container(
        color: Colors.white,
        child: SizedBox(
          width: 100.0,
          child: Align(
            alignment: Alignment.center,
            child: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                child: Text(
                  Helper.getExactTitleTrending(snapshot, index),
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
