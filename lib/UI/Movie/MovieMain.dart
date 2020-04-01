import 'package:flutter/material.dart';
import 'package:md2_tab_indicator/md2_tab_indicator.dart';
import 'package:themoviesdb/UI/Movie/NowPlaying.dart';
import 'package:themoviesdb/UI/Movie/TopRated.dart';
import 'package:themoviesdb/UI/Movie/Upcoming.dart';
import 'package:themoviesdb/UI/navigationDrawer.dart';

import 'Popular.dart';

class MovieMain extends StatefulWidget {
  @override
  _MovieMainState createState() => _MovieMainState();
}

class _MovieMainState extends State<MovieMain> with SingleTickerProviderStateMixin {
  TabController _controller;

  @override
  void initState() {
    _controller = TabController(length: 4, vsync: this, initialIndex: 0);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      drawer: navigationDrawer(context),
      appBar: AppBar(
        centerTitle: false,
        title: Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
          Image(width: 35, height: 35, image: ExactAssetImage('assets/images/icon_logo.png')),
          SizedBox(width: 10),
          Text('MOVIES', style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold))
        ]),
        bottom: _getTabBar(),
      ),
      body: _getContent(),
    );
  }

  _getTabBar() {
    return TabBar(
      controller: _controller,
      labelStyle: TextStyle(fontWeight: FontWeight.w700),
      indicatorSize: TabBarIndicatorSize.label,
      labelColor: Color(0xFF01d277),
      unselectedLabelColor: Colors.white,
      isScrollable: true,
      indicator: MD2Indicator(
          //it begins here
          indicatorHeight: 3,
          indicatorColor: Color(0xFF01d277),
          indicatorSize: MD2IndicatorSize.normal),
      tabs: <Widget>[
        Tab(text: "Popular".toUpperCase()),
        Tab(text: "Now Playing".toUpperCase()),
        Tab(text: "Upcoming".toUpperCase()),
        Tab(text: "Top Rated".toUpperCase())
      ],
    );
  }

  _getContent() {
    return TabBarView(controller: _controller, children: <Widget>[Popular(), NowPlaying(), Upcoming(), TopRated()]);
  }
}
