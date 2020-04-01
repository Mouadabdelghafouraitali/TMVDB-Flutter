import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:themoviesdb/Models/SearchModel/SearchMovie.dart';
import 'package:themoviesdb/Models/SearchModel/SearchTVShow.dart';
import 'package:themoviesdb/Models/inShortModel/InShortGenreList.dart';
import 'package:themoviesdb/Utils/FutureHelper.dart';
import 'package:themoviesdb/Utils/Helper.dart';
import 'package:themoviesdb/Utils/WidgetHelper.dart';

import 'Movie/MovieDetails.dart';
import 'TVShow/TVShowDetails.dart';

class SearchList extends StatefulWidget {
  SearchList({Key key}) : super(key: key);

  @override
  _SearchListState createState() => new _SearchListState();
}

class _SearchListState extends State<SearchList> {
  Widget appBarTitle = Text("Explore Now");
  Icon actionIcon = Icon(Icons.search);
  var _controller = TextEditingController();
  Icon selectedIcon = Icon(Icons.movie, color: Colors.white);
  String _searchHint;
  List<InShortGenreList> inShortGenreList = [];
  var _body;
  SearchFilter _searchType;

  var _searchQuery;

  @override
  void initState() {
    _searchHint = 'Movie';
    _searchType = SearchFilter.MOVIES;
    _body = WidgetHelper.getImgState('Waiting to search!', 'assets/images/waiting_search.png');
    FutureHelper.getListGenres().then((genreList) {
      for (var genre in genreList.genres) {
        inShortGenreList.add(InShortGenreList(id: genre.id, name: genre.name));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _searchOptions();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      appBar: AppBar(
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios, color: Color(0xFF01d277)),
            onPressed: () => Navigator.of(context).pop(),
          ),
          centerTitle: false,
          title: appBarTitle,
          actions: <Widget>[
            IconButton(
              icon: actionIcon,
              onPressed: () {
                setState(() {
                  _controller.clear();
                });
              },
            ),
            IconButton(
                icon: Icon(Icons.list, color: Colors.white),
                onPressed: () {
                  _showPopUpMenu();
                })
          ]),
      body: _body,
    );
  }

  _searchOptions() {
    this.actionIcon = Icon(Icons.close);
    this.appBarTitle = TextField(
      controller: _controller,
      textInputAction: TextInputAction.go,
      autofocus: false,
      style: TextStyle(color: Colors.white),
      decoration:
          InputDecoration(prefixIcon: Icon(Icons.search, color: Colors.white), hintText: _searchHint, hintStyle: new TextStyle(color: Colors.grey)),
      onSubmitted: (value) {
        setState(() {
          _searchQuery = value;
          _body = _getSearchResult(value.replaceAll(' ', '%20'), _searchType);
        });
      },
    );
  }

  _showPopUpMenu() {
    showMenu(
      position: RelativeRect.fromLTRB(65.0, 40.0, 0.0, 0.0),
      context: context,
      color: Colors.black,
      items: [
        PopupMenuItem<SearchFilter>(
          value: SearchFilter.MOVIES,
          child: Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            Icon(Icons.movie, color: Colors.white),
            SizedBox(width: 8.0),
            Text('Movies', style: TextStyle(color: Colors.white))
          ]),
        ),
        PopupMenuItem<SearchFilter>(
            value: SearchFilter.TVSHOWS,
            child: Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              Icon(Icons.live_tv, color: Colors.white),
              SizedBox(width: 8.0),
              Text('TV Shows', style: TextStyle(color: Colors.white))
            ]))
      ],
    ).then((value) {
      switch (value) {
        case SearchFilter.MOVIES:
          setState(() {
            _searchHint = 'Movie';
            _searchType = SearchFilter.MOVIES;
            if (_searchQuery.toString().isNotEmpty) _body = _getSearchResult(_searchQuery.replaceAll(' ', '%20'), _searchType);
          });
          break;
        case SearchFilter.TVSHOWS:
          setState(() {
            _searchHint = 'TV show';
            _searchType = SearchFilter.TVSHOWS;
            if (_searchQuery.toString().isNotEmpty) _body = _getSearchResult(_searchQuery.replaceAll(' ', '%20'), _searchType);
          });
          break;
      }
    });
  }

  _getSearchResult(String query, SearchFilter searchFilter) {
    Helper.showToast('Searching...', context);
    if (searchFilter == SearchFilter.MOVIES) {
      setState(() {
        _searchType = SearchFilter.MOVIES;
      });
      return Container(
          child: FutureBuilder<SearchMovie>(
        future: FutureHelper.getSearchedMovies(query),
        builder: (BuildContext context, AsyncSnapshot<SearchMovie> snapshot) {
          if (snapshot.hasData && snapshot.data.results != null) {
            if (snapshot.data.results.length > 0) {
              return ListView.builder(
                  itemBuilder: (context, index) {
                    return _itemMovie(snapshot, index);
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
    } else if (searchFilter == SearchFilter.TVSHOWS) {
      setState(() {
        _searchType = SearchFilter.TVSHOWS;
      });
      return Container(
          child: FutureBuilder<SearchTvShow>(
        future: FutureHelper.getSearchedTVShow(query),
        builder: (BuildContext context, AsyncSnapshot<SearchTvShow> snapshot) {
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
  }

  _itemMovie(AsyncSnapshot<SearchMovie> snapshot, int index) {
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
                heroId: '${snapshot.data.results[index].id}search');
          }));
        },
        child: Hero(
          tag: '${snapshot.data.results[index].id}search',
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

  _getDetails(AsyncSnapshot<SearchMovie> snapshot, int index) {
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

  _subDetails(AsyncSnapshot<SearchMovie> snapshot, int index) {
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

  _itemTVShow(AsyncSnapshot<SearchTvShow> snapshot, int index) {
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
                heroId: '${snapshot.data.results[index].id}search');
          }));
        },
        child: Hero(
          tag: '${snapshot.data.results[index].id}search',
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

  _getTVShowDetails(AsyncSnapshot<SearchTvShow> snapshot, int index) {
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

  _subTVShowDetails(AsyncSnapshot<SearchTvShow> snapshot, int index) {
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

enum SearchFilter { MOVIES, TVSHOWS }
