import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags/selectable_tags.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:themoviesdb/Models/ByPerson.dart';
import 'package:themoviesdb/Models/Credits.dart';
import 'package:themoviesdb/Models/Movie.dart';
import 'package:themoviesdb/Models/Person.dart';
import 'package:themoviesdb/Models/Reviews.dart';
import 'package:themoviesdb/Models/Similar.dart';
import 'package:themoviesdb/Models/Videos.dart';
import 'package:themoviesdb/Utils/Constants.dart';
import 'package:themoviesdb/Utils/FutureHelper.dart';
import 'package:themoviesdb/Utils/Helper.dart';
import 'package:themoviesdb/Utils/SharedPref.dart';
import 'package:themoviesdb/Utils/WidgetHelper.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../ByGenres/MoviesByGenre.dart';
import '../TVShow/TVShowDetails.dart';

class MovieDetails extends StatefulWidget {
  int id;
  String title;
  String overview;
  String backdropPath;
  String posterPath;
  double voteAverage;
  String heroId;

  MovieDetails({this.id, this.title, this.overview, this.backdropPath, this.posterPath, this.voteAverage, this.heroId});

  @override
  _MovieDetailsState createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> with SingleTickerProviderStateMixin {
  double mHeight = 140.0;
  YoutubePlayerController _controller;
  bool _isPlayerReady = false;
  PlayerState _playerState;
  YoutubeMetaData _videoMetaData;
  String key;
  SharedPref sharedPref = SharedPref();
  bool isMarkedAsFavorite = false;
  IconData iconData;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: BoxConstraints.expand(),
        color: Color(0xFF000000),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Stack(
            children: <Widget>[
              _getBackground(widget.backdropPath),
              _getBackgroundGradient(),
              _getToolbar(context),
              _getContent(),
            ],
          ),
        ),
      ),
    );
  }

  _getSubContent() {
    return Column(children: <Widget>[
      _getGenres(widget.id),
      Divider(thickness: 0.2, color: Color(0xFF01d277)),
      _getOverview(widget.overview),
      Divider(thickness: 0.2, color: Color(0xFF01d277)),
      _getVideos(widget.id),
      Divider(thickness: 0.2, color: Color(0xFF01d277)),
      _getReviews(widget.id),
      Divider(thickness: 0.2, color: Color(0xFF01d277)),
      _getCasts(widget.id),
      _getCrew(widget.id),
      Divider(thickness: 0.2, color: Color(0xFF01d277)),
      _getProductionCompanies(widget.id),
      Divider(thickness: 0.2, color: Color(0xFF01d277)),
      _getSimilarMovies(widget.id)
    ]);
  }

  _getBackground(String URL) {
    return Helper.loadImage(URL, 250.0, MediaQuery.of(context).size.width, context, BoxFit.cover);
  }

  _getBackgroundGradient() {
    return Container(
      margin: new EdgeInsets.only(top: 130.0),
      height: 120.0,
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

  _getToolbar(BuildContext context) {
    return AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Color(0xFF01d277),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ));
  }

  _getGenres(int id) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text('• Genres', textAlign: TextAlign.left, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24.0)),
          ),
          Container(
            width: double.infinity,
            height: 20,
            child: FutureBuilder<Movie>(
                future: FutureHelper.getMovie(id),
                builder: (BuildContext context, AsyncSnapshot<Movie> snapshot) {
                  List<Tag> tagList = [];
                  if (snapshot.hasData && snapshot.data.genres != null) {
                    for (var genres in snapshot.data.genres) {
                      tagList.add(Tag(title: genres.name, id: genres.id));
                    }
                    if (snapshot.data.genres.length == 0)
                      return Text('No genres found for this movie', style: TextStyle(color: Colors.white));
                    else
                      return ListView.builder(
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: tagList.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                              child: OutlineButton(
                                  child: Text(tagList[index].title, style: TextStyle(color: Colors.white, fontSize: 14.0)),
                                  onPressed: () {
                                    int id = snapshot.data.genres[index].id ?? 0; //0 as id to avoid the null exception
                                    String name = snapshot.data.genres[index].name ?? 'Unknown genre'; //Unknown genre as name to avoid the null
                                    // exception
                                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                                      return MoviesByGenre(id: id, name: name);
                                    }));
                                  },
                                  borderSide: BorderSide(color: Colors.white, style: BorderStyle.solid, width: 1)),
                            );
                          });
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
                }),
          ),
        ],
      ),
    );
  }

  _getContent() {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 90),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  widget.title,
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22.0),
                ),
              ),
              Container(
                  child: Row(
                children: <Widget>[
                  Hero(
                    tag: widget.heroId,
                    child: SizedBox(
                      width: 100,
                      height: 150,
                      child: Helper.loadImage(widget.posterPath, 150, MediaQuery.of(context).size.width, context, BoxFit.cover),
                    ),
                  ),
                  FutureBuilder<Movie>(
                    future: FutureHelper.getMovie(widget.id),
                    builder: (BuildContext context, AsyncSnapshot<Movie> snapshot) {
                      if (snapshot.hasData) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new CircularPercentIndicator(
                                radius: 40.0,
                                lineWidth: 4.0,
                                animation: true,
                                percent: widget.voteAverage * 0.1,
                                center: new Text(
                                  Helper.getExactRatingPercentage(widget.voteAverage),
                                  style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 10.0, color: Colors.white),
                                ),
                                footer: Padding(
                                  padding: const EdgeInsets.only(top: 2.0, bottom: 2.0),
                                  child: new Text(
                                    "User Score",
                                    style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0, color: Colors.white),
                                  ),
                                ),
                                circularStrokeCap: CircularStrokeCap.round,
                                fillColor: Colors.transparent,
                                backgroundColor: Color(0xFF204529),
                                progressColor: Helper.getExactRatingColor(widget.voteAverage),
                              ),
                              Text(
                                '• Release date : ${Helper.getExactDateWithoutDay(snapshot.data.releaseDate)}',
                                style: TextStyle(color: Colors.white, height: 1.5),
                              ),
                              Text(
                                '• Runtime : ${Helper.getExactTime(snapshot.data.runtime)}',
                                style: TextStyle(color: Colors.white, height: 1.5),
                              ),
                              Text(
                                '• Budget : ${Helper.getExactCurrency(snapshot.data.budget)}',
                                style: TextStyle(color: Colors.white, height: 1.5),
                              ),
                              Text(
                                '• Revenue : ${Helper.getExactCurrency(snapshot.data.revenue)}',
                                style: TextStyle(color: Colors.white, height: 1.5),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return Container();
                      }
                    },
                  )
                ],
              )),
            ]),
          ),
        ),
        _getSubContent()
      ],
    );
  }

  _getOverview(String overview) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text('• Overview', textAlign: TextAlign.left, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24.0)),
        ),
        Text(overview, style: TextStyle(color: Colors.white, fontWeight: FontWeight.normal, fontSize: 14))
      ]),
    );
  }

  _getVideos(int id) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text('• Videos & Trailers',
                textAlign: TextAlign.left, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24.0)),
          ),
        ),
        FutureBuilder<Videos>(
          future: FutureHelper.getVideos(id),
          builder: (BuildContext context, AsyncSnapshot<Videos> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.results == null || snapshot.data.results.length == 0) {
                return Center(
                  child: Text(
                    'No video trailer available',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              } else {
                return Container(
                  height: 140.0,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data.results.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                            onTap: () {
                              setState(() {
                                key = snapshot.data.results[index].key;
                              });
                              showSheetDialog(snapshot.data.results[index].key.toString());
                            },
                            child: Container(
                                child: _getVideoItem(snapshot.data.results[index].key, snapshot.data.results[index].name ?? 'Video Trailer'),
                                width: 180.0));
                      }),
                );
              }
            } else {
              return Center(
                child: SizedBox(
                    width: 32,
                    height: 32,
                    child: CircularProgressIndicator(
                      backgroundColor: Color(0xFF01d277),
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                      strokeWidth: 2.0,
                    )),
              );
            }
          },
        ),
      ]),
    );
  }

  _getVideoItem(String key, String title) {
    return ClipRRect(
      child: Card(
          shape: BeveledRectangleBorder(borderRadius: Helper.getExactRadiusValue(1.5)),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          color: Colors.white,
          elevation: 0.3,
          child: Column(
            children: <Widget>[
              Flexible(
                  flex: 3,
                  child: Stack(
                    children: <Widget>[
                      Helper.getYoutubeThumbnail(key, context, 100.0),
                      Center(
                          child: Container(
                        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white)),
                        child: Icon(
                          Icons.play_circle_outline,
                          color: Colors.white,
                        ),
                      )),
                    ],
                  )),
              Flexible(
                  flex: 1,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                      child: Text(
                        title,
                        style: TextStyle(color: Colors.black, fontSize: 9.0),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                  ))
            ],
          )),
    );
  }

  showSheetDialog(String key) {
    _controller = YoutubePlayerController(
      initialVideoId: key,
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return ClipRRect(
              borderRadius: BorderRadius.only(topRight: Radius.circular(12.0), topLeft: Radius.circular(12.0)),
              child: Container(
                color: Colors.black,
                height: 280.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(crossAxisAlignment: CrossAxisAlignment.end, mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                        Image(
                          image: ExactAssetImage('assets/images/youtube_logo.png'),
                          width: 28,
                          height: 20,
                        ),
                        Text(' Youtube', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        Text(' Trailer', style: TextStyle(color: Colors.white, fontWeight: FontWeight.normal))
                      ]),
                    ),
                    YoutubePlayer(
                      controller: _controller,
                      showVideoProgressIndicator: true,
                      onReady: () {
                        _isPlayerReady = true;
                        _controller.addListener(listener);
                      },
                    )
                  ],
                ),
              ));
        },
        context: context);
  }

  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {
        _playerState = _controller.value.playerState;
        _videoMetaData = _controller.metadata;
      });
    } else {
      _controller.reload();
    }
  }

  _getReviews(int id) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text('• Reviews', textAlign: TextAlign.left, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24.0)),
          ),
        ),
        FutureBuilder<Reviews>(
          future: FutureHelper.getReviews(id),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.results == null || snapshot.data.results.length == 0) {
                return Center(
                  child: Text(
                    'No reviews available',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              } else {
                return Container(
                  height: 120,
                  child: ListView.builder(
                    itemCount: snapshot.data.results.length,
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        child: Container(
                          width: 300,
                          child: Column(children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                              child: Row(
                                children: <Widget>[
                                  CircleAvatar(
                                      backgroundColor: Color(0xFF01d277),
                                      child: Text(snapshot.data.results[index].author.substring(0, 1).toUpperCase() ?? 'T',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold))),
                                  SizedBox(width: 4.0),
                                  Text(snapshot.data.results[index].author ?? 'TMVDB User',
                                      style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold))
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(snapshot.data.results[index].content.replaceAll('\n', '').replaceAll('\r', '') ?? no_review,
                                  style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis),
                            )
                          ]),
                        ),
                        onTap: () {
                          Helper.launchURL(snapshot.data.results[index].url ?? no_url);
                        },
                      );
                    },
                  ),
                );
              }
            } else {
              return Center(
                child: SizedBox(
                    width: 32,
                    height: 32,
                    child: CircularProgressIndicator(
                      backgroundColor: Color(0xFF01d277),
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                      strokeWidth: 2.0,
                    )),
              );
            }
          },
        )
      ]),
    );
  }

  _getCasts(int id) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text('• Casts', textAlign: TextAlign.left, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24.0)),
          ),
        ),
        FutureBuilder<Credits>(
          future: FutureHelper.getCredits(id, movie),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.cast == null || snapshot.data.cast.length == 0) {
                return Center(
                  child: Text(
                    'No casts information available',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              } else {
                return Column(
                  children: <Widget>[
                    Container(
                      height: 180,
                      child: ListView.builder(
                        itemCount: snapshot.data.cast.length,
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            child: Container(
                                width: 100,
                                child: Hero(
                                  tag: '${snapshot.data.cast[index].id}cast',
                                  child: ClipRRect(
                                    child: Card(
                                      shape: BeveledRectangleBorder(borderRadius: Helper.getExactRadiusValue(1.5)),
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      elevation: 0.3,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Helper.loadImage(Helper.getCastProfilePicture(snapshot, index), 100, MediaQuery.of(context).size.width,
                                              context, BoxFit.cover),
                                          _getBottomCasts(
                                              snapshot.data.cast[index].name ?? 'Unknown cast', snapshot.data.cast[index].character ?? 'Unknown')
                                        ],
                                      ),
                                    ),
                                  ),
                                )),
                            onTap: () {
                              _showSheetPersonInformationDialog(snapshot, index, snapshot.data.cast[index].id, Jobs.CAST);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                );
              }
            } else {
              return Center(
                child: SizedBox(
                    width: 32,
                    height: 32,
                    child: CircularProgressIndicator(
                      backgroundColor: Color(0xFF01d277),
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                      strokeWidth: 2.0,
                    )),
              );
            }
          },
        )
      ]),
    );
  }

  _getBottomCasts(String name, String character) {
    return Expanded(
        child: Container(
      color: Colors.white,
      child: SizedBox(
        width: 100.0,
        child: Align(
          alignment: Alignment.center,
          child: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            Text(
              name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 10.0),
              textAlign: TextAlign.center,
            ),
            Text(
              '(${character})',
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.normal, fontSize: 8.0),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ]),
        ),
      ),
    ));
  }

  _getCrew(int id) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text('• Crew', textAlign: TextAlign.left, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24.0)),
          ),
        ),
        FutureBuilder<Credits>(
          future: FutureHelper.getCredits(id, movie),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.crew == null || snapshot.data.crew.length == 0) {
                return Center(
                  child: Text(
                    'No crew information available',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              } else {
                return Column(
                  children: <Widget>[
                    Container(
                      height: 180,
                      child: ListView.builder(
                        itemCount: snapshot.data.crew.length,
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            child: Container(
                                width: 100,
                                child: ClipRRect(
                                  child: Card(
                                    shape: BeveledRectangleBorder(borderRadius: Helper.getExactRadiusValue(1.5)),
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    elevation: 0.3,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Helper.loadImage(Helper.getCrewProfilePicture(snapshot, index), 100, MediaQuery.of(context).size.width,
                                            context, BoxFit.cover),
                                        _getBottomCrew(snapshot.data.crew[index].name ?? 'Unknown', snapshot.data.crew[index].job ?? 'Unknown')
                                      ],
                                    ),
                                  ),
                                )),
                            onTap: () {
                              _showSheetPersonInformationDialog(snapshot, index, snapshot.data.crew[index].id, Jobs.CREW);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                );
              }
            } else {
              return Center(
                child: SizedBox(
                    width: 32,
                    height: 32,
                    child: CircularProgressIndicator(
                      backgroundColor: Color(0xFF01d277),
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                      strokeWidth: 2.0,
                    )),
              );
            }
          },
        )
      ]),
    );
  }

  _getBottomCrew(String name, String character) {
    return Expanded(
        child: Container(
      color: Colors.white,
      child: SizedBox(
        width: 100.0,
        child: Align(
          alignment: Alignment.center,
          child: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            Text(
              name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 10.0),
              textAlign: TextAlign.center,
            ),
            Text(
              '(${character})',
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.normal, fontSize: 8.0),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ]),
        ),
      ),
    ));
  }

  _getProductionCompanies(int id) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text('• Production Companies',
                textAlign: TextAlign.left, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24.0)),
          ),
        ),
        FutureBuilder<Movie>(
          future: FutureHelper.getMovie(id),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.productionCompanies == null || snapshot.data.productionCompanies.length == 0) {
                return Center(
                  child: Text(
                    'No information available',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              } else {
                return Container(
                  height: 120,
                  child: ListView.builder(
                    itemCount: snapshot.data.productionCompanies.length,
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        child: Container(
                          width: 100,
                          child: Column(children: <Widget>[
                            Expanded(
                              child: ClipRRect(
                                child: Card(
                                  shape: BeveledRectangleBorder(borderRadius: Helper.getExactRadiusValue(1.5)),
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  elevation: 0.3,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                                    child: Center(
                                      child: Column(
                                        children: <Widget>[
                                          Helper.getCompanyWorkingImage(snapshot.data.productionCompanies[index].logoPath ?? null, context),
                                          SizedBox(height: 4.0),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                                            child: Text(
                                              snapshot.data.productionCompanies[index].name ?? 'Production\nCompany',
                                              style: TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.center,
                                              maxLines: 2,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ]),
                        ),
                        onTap: () {
                          //
                          //Helper.launchURL(snapshot.data.productionCompanies[index].url);
                        },
                      );
                    },
                  ),
                );
              }
            } else {
              return Center(
                child: SizedBox(
                    width: 32,
                    height: 32,
                    child: CircularProgressIndicator(
                      backgroundColor: Color(0xFF01d277),
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                      strokeWidth: 2.0,
                    )),
              );
            }
          },
        )
      ]),
    );
  }

  _getSimilarMovies(int id) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
      Padding(
        padding: const EdgeInsets.only(left: 4.0, top: 16.0, bottom: 16.0),
        child: Text(
          '• Similar Movies',
          style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      Container(
          height: 190,
          child: FutureBuilder<Similar>(
            future: FutureHelper.getSimilarMovies(id),
            builder: (BuildContext context, AsyncSnapshot<Similar> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.results.length > 0) {
                  return ListView.builder(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data.results.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          child: Container(
                              width: 100.0,
                              child: Hero(
                                tag: '${snapshot.data.results[index].id}similar',
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
                                              _itemBottomSimilar(snapshot, index),
                                            ],
                                          )),
                                        ],
                                      )),
                                ),
                              )),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return MovieDetails(
                                  id: snapshot.data.results[index].id,
                                  title: Helper.getExactTitleName(snapshot, index),
                                  overview: Helper.getExactOverview(snapshot, index),
                                  posterPath: Helper.getExactPoster(snapshot, index),
                                  backdropPath: Helper.getExactCover(snapshot, index),
                                  voteAverage: Helper.getExactVoteAverage(snapshot, index),
                                  heroId: '${snapshot.data.results[index].id}similar');
                            }));
                          },
                        );
                      });
                } else {
                  return Center(
                    child: Text(
                      'No Similar movie available',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }
              } else {
                return WidgetHelper.getCircularProgress(190.0);
              }
            },
          ))
    ]);
  }

  _itemBottomSimilar(AsyncSnapshot<Similar> snapshot, int index) {
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
                  Helper.getExactTitle(snapshot, index),
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

  _showSheetPersonInformationDialog(AsyncSnapshot<Credits> snapshot, int index, int id, Jobs job) {
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return ClipRRect(
              borderRadius: BorderRadius.only(topRight: Radius.circular(12.0), topLeft: Radius.circular(12.0)),
              child: Container(
                color: Colors.black,
                height: 500.0,
                width: double.infinity,
                child: Column(children: <Widget>[_getPersonalInformation(snapshot, index, job), _getCredits(id, job)]),
              ));
        },
        context: context);
  }

  _getPersonalInformation(AsyncSnapshot<Credits> person, int index, Jobs job) {
    var data;
    int id;
    if (job == Jobs.CAST) {
      data = person.data.cast[index];
      id = person.data.cast[index].id;
    } else {
      data = person.data.crew[index];
      id = person.data.crew[index].id;
      print('ID = ' + id.toString());
    }
    return FutureBuilder<Person>(
        future: FutureHelper.getPerson(id),
        builder: (BuildContext context, AsyncSnapshot<Person> snapshot) {
          if (snapshot.hasData) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 4.0),
                      Hero(
                        tag: '${data.id}cast',
                        child: Container(
                          width: 80.0,
                          height: 80.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: new DecorationImage(
                              fit: BoxFit.cover,
                              image: CachedNetworkImageProvider(Helper.getExactProfilePicture(snapshot)),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 4.0),
                      RichText(
                        text: TextSpan(
                            text: data.name,
                            style: TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold),
                            children: <TextSpan>[]),
                      ),
                      SizedBox(height: 4.0),
                      GestureDetector(
                        onTap: () {
                          Helper.launchURL(person_url + snapshot.data.id.toString());
                        },
                        child: Text('${Helper.getExactBio(snapshot.data.biography, data.name)}',
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 12.0, fontWeight: FontWeight.normal)),
                      ),
                      SizedBox(height: 4.0),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Center(child: WidgetHelper.getCircularProgress(250.0));
          }
        });
  }

  _getCredits(int id, Jobs job) {
    int count = 0;
    var person;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
      FutureBuilder<ByPerson>(
        future: FutureHelper.getByPerson(id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (job == Jobs.CAST) {
              if (snapshot.data.cast == null || snapshot.data.cast.length == 0) {
                return Center(
                  child: Text(
                    'No information available',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              } else {
                count = snapshot.data.cast.length;
                person = snapshot.data.cast;
              }
            } else if (snapshot.data.crew == null || snapshot.data.crew.length == 0) {
              return Center(
                child: Text(
                  'No information available',
                  style: TextStyle(color: Colors.white),
                ),
              );
            } else {
              count = snapshot.data.crew.length;
              person = snapshot.data.crew;
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
                  child: Text('Known For', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16.0)),
                ),
                Container(
                  height: 120,
                  child: ListView.builder(
                    itemCount: count,
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        child: Hero(
                          tag: widget.heroId,
                          child: Container(
                              width: 80,
                              child: ClipRRect(
                                child: Card(
                                  shape: BeveledRectangleBorder(borderRadius: Helper.getExactRadiusValue(1.5)),
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  elevation: 0.3,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Helper.loadImage(Helper.getExactCreditsPoster(snapshot, index, job), 80, MediaQuery.of(context).size.width,
                                          context, BoxFit.cover),
                                      _getBottom(Helper.getExactCreditsTitleName(snapshot, index, job))
                                    ],
                                  ),
                                ),
                              )),
                        ),
                        onTap: () {
                          if (person[index].mediaType == MediaType.MOVIE) {
                            Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return _gotoMovieDetails(snapshot, index, job);
                            }));
                          } else {
                            Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return _gotoTVShowDetails(snapshot, index, job);
                            }));
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          } else {
            return Container();
          }
        },
      )
    ]);
  }

  _getBottom(String title) {
    return Expanded(
        child: Container(
      color: Colors.white,
      child: SizedBox(
        width: 50.0,
        child: Align(
          alignment: Alignment.center,
          child: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 8.0),
              textAlign: TextAlign.center,
            )
          ]),
        ),
      ),
    ));
  }

  _gotoMovieDetails(AsyncSnapshot<ByPerson> snapshot, int index, Jobs job) {
    if (job == Jobs.CAST) {
      return MovieDetails(
          id: snapshot.data.cast[index].id,
          title: Helper.getExactCreditsTitleName(snapshot, index, job),
          overview: Helper.getExactCreditsOverview(snapshot, index, job),
          posterPath: Helper.getExactCreditsPoster(snapshot, index, job),
          backdropPath: Helper.getExactCreditsCover(snapshot, index, job),
          voteAverage: Helper.getExactCreditVoteAverage(snapshot, index, job),
          heroId: '${snapshot.data.cast[index].id}byperson');
    } else {
      return MovieDetails(
          id: snapshot.data.crew[index].id,
          title: Helper.getExactCreditsTitleName(snapshot, index, job),
          overview: Helper.getExactCreditsOverview(snapshot, index, job),
          posterPath: Helper.getExactCreditsPoster(snapshot, index, job),
          backdropPath: Helper.getExactCreditsCover(snapshot, index, job),
          voteAverage: Helper.getExactCreditVoteAverage(snapshot, index, job),
          heroId: '${snapshot.data.crew[index].id}byperson');
    }
  }

  _gotoTVShowDetails(AsyncSnapshot<ByPerson> snapshot, int index, Jobs job) {
    if (job == Jobs.CAST) {
      return TVShowDetails(
          id: snapshot.data.cast[index].id,
          title: Helper.getExactCreditsTitleName(snapshot, index, job),
          overview: Helper.getExactCreditsOverview(snapshot, index, job),
          posterPath: Helper.getExactCreditsPoster(snapshot, index, job),
          backdropPath: Helper.getExactCreditsCover(snapshot, index, job),
          voteAverage: Helper.getExactCreditVoteAverage(snapshot, index, job),
          heroId: '${snapshot.data.cast[index].id}byperson');
    } else {
      return TVShowDetails(
          id: snapshot.data.crew[index].id,
          title: Helper.getExactCreditsTitleName(snapshot, index, job),
          overview: Helper.getExactCreditsOverview(snapshot, index, job),
          posterPath: Helper.getExactCreditsPoster(snapshot, index, job),
          backdropPath: Helper.getExactCreditsCover(snapshot, index, job),
          voteAverage: Helper.getExactCreditVoteAverage(snapshot, index, job),
          heroId: '${snapshot.data.crew[index].id}byperson');
    }
  }
}
