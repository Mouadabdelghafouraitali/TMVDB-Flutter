import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:themoviesdb/UI/Home.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  List<ItemContent> listItems = [];
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    setItemsData(listItems);
    return Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: <Widget>[
            PageView.builder(
              itemBuilder: (context, index) {
                return Stack(
                  children: <Widget>[
                    Center(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Transform.translate(
                          offset: Offset(0, -10),
                          child: Image(
                            image: ExactAssetImage(getItemsData(index).imagePath),
                            width: 160,
                            height: 160,
                          ),
                        ),
                        Text(
                          getItemsData(index).title,
                          style: TextStyle(color: Color(0xFF01d277), fontSize: 20, height: 2, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 4.0, bottom: 4.0),
                          child: Text(
                            getItemsData(index).description,
                            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.normal),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    )),
                  ],
                );
              },
              itemCount: 3,
              onPageChanged: (index) {
                setState(() {
                  //update UI
                  _index = index;
                });
              },
            ),
            Transform.translate(
              offset: Offset(0, 200),
              child: Align(
                alignment: Alignment.center,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new DotsIndicator(
                      dotsCount: 3,
                      position: _index.toDouble(),
                      decorator: DotsDecorator(
                        activeColor: Color(0xFF01d277),
                        size: const Size.square(9.0),
                        activeSize: const Size(18.0, 9.0),
                        activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: RaisedButton(
                    child: Text(
                      "Explore now".toUpperCase(),
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20.0),
                      textAlign: TextAlign.center,
                    ),
                    color: Color(0xFF01d277),
                    elevation: 4,
                    textColor: Colors.white,
                    onPressed: () {
                      onStartedClicked();
                    },
                  ),
                ),
              ),
            )
          ],
        ));
  }

  void setItemsData(List<ItemContent> listItems) {
    listItems.add(ItemContent('Movies', 'Do you like watching movies?', 'assets/images/movies.png'));
    listItems.add(ItemContent('TV Shows', "Or you prefer watching the series", 'assets/images/tvshow.png'));
    listItems.add(ItemContent('Welcome', 'Millions of movies, TV shows and people to discover. Explore now.', 'assets/images/welcome.png'));
  }

  ItemContent getItemsData(int Index) {
    return listItems[Index];
  }

  onStartedClicked() {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return Home();
    }));
  }
}

class ItemContent {
  String title;
  String description;
  String imagePath;

  ItemContent(this.title, this.description, this.imagePath);
}
