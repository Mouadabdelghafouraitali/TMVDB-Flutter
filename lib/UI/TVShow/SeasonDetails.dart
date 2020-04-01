import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:themoviesdb/Models/SeasonInfo.dart';
import 'package:themoviesdb/Utils/Constants.dart';
import 'package:themoviesdb/Utils/FutureHelper.dart';
import 'package:themoviesdb/Utils/Helper.dart';
import 'package:themoviesdb/Utils/WidgetHelper.dart';

class SeasonDetails extends StatefulWidget {
  String name;
  int id;
  int number;
  String heroId;
  String overview;
  String posterPath;
  String airDate;
  int episode_count;

  SeasonDetails({this.name, this.id, this.number, this.heroId, this.overview, this.posterPath, this.airDate, this.episode_count});

  @override
  _SeasonDetailsState createState() => _SeasonDetailsState();
}

class _SeasonDetailsState extends State<SeasonDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: BoxConstraints.expand(),
        color: Color(0xFF000000),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Stack(
            children: <Widget>[_getBackground(widget.posterPath), _getBackgroundGradient(130.0), _getToolbar(context), _getContent()],
          ),
        ),
      ),
    );
  }

  _getBackground(String URL) {
    return Helper.loadImage(URL, 250.0, MediaQuery.of(context).size.width, context, BoxFit.cover);
  }

  _getBackgroundGradient(double topValue) {
    return Container(
      margin: new EdgeInsets.only(top: topValue),
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

  _getTitle() {
    return Container(
      height: 220,
      margin: EdgeInsets.only(bottom: 30),
      padding: EdgeInsets.only(left: 8.0),
      alignment: Alignment.bottomLeft,
      child: Text('• ${widget.name} (${widget.airDate})',
          textAlign: TextAlign.left, maxLines: 4, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white, fontSize: 24.0)),
    );
  }

  _getContent() {
    return Column(children: <Widget>[_getTitle(), _getOverview(), Divider(thickness: 0.2, color: Color(0xFF01d277)), _getListEpisodes()]);
  }

  _getOverview() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text('• Overview', textAlign: TextAlign.left, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24.0)),
        ),
        Text(widget.overview, textAlign: TextAlign.left, style: TextStyle(color: Colors.white, fontWeight: FontWeight.normal, fontSize: 14))
      ]),
    );
  }

  _getListEpisodes() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
      Padding(
        padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
        child: Text('• Episodes ${widget.episode_count}',
            textAlign: TextAlign.left, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24.0)),
      ),
      Container(
          child: FutureBuilder<SeasonInfo>(
              future: FutureHelper.getSeasonInformation(widget.id, widget.number),
              builder: (BuildContext context, AsyncSnapshot<SeasonInfo> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.episodes.length > 0) {
                    return ListView.builder(
                        primary: false,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemCount: snapshot.data.episodes.length,
                        itemBuilder: (context, index) {
                          return _getEpisode(snapshot, index);
                        });
                  } else {
                    return Center(
                      child: Text(
                        'No episode available',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }
                } else
                  return WidgetHelper.getCircularProgress(80);
              }))
    ]);
  }

  _getEpisode(AsyncSnapshot<SeasonInfo> snapshot, int index) {
    return ClipRRect(
      child: Card(
          shape: BeveledRectangleBorder(borderRadius: Helper.getExactRadiusValue(1.5)),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 140.0,
                width: double.infinity,
                child: Stack(
                  children: <Widget>[
                    Helper.loadImage(
                        Helper.getExactSeasonStillPath(snapshot, index), 140.0, MediaQuery.of(context).size.width, context, BoxFit.cover),
                    Align(
                      alignment: Alignment.topRight,
                      child: SizedBox(
                          height: 20,
                          width: 50,
                          child: Container(
                            alignment: Alignment.topRight,
                            color: MaterialColor(0xFF01F277, Helper.color),
                            child: Center(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(width: 2.0),
                                  Helper.getExactRating(Helper.getExactSeasonRatingValue(snapshot, index)),
                                  SizedBox(width: 2.0),
                                  Text(
                                    Helper.getExactSeasonRatingValue(snapshot, index),
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                                  ),
                                ],
                              ),
                            ),
                          )),
                    ),
                    Align(alignment: Alignment.bottomCenter, child: _getBackgroundGradient(100.0)),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Text('• ${Helper.getExactSeasonEpisodeName(snapshot, index)}',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style: TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold))),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text('• Overview : ${Helper.getExactSeasonOverview(snapshot.data.episodes[index].overview.toString())}',
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    maxLines: 3,
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 12)),
              )
            ],
          )),
    );
  }

  String _getOverviewText(String overview) {
    if (overview.isNotEmpty)
      return '• Overview : ${overview}';
    else
      return help_tmvdb;
  }
}
