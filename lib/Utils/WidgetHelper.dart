import 'package:flutter/material.dart';

class WidgetHelper {
  static getCircularProgress(double height) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: double.infinity,
          height: height,
          child: Center(
            child: SizedBox(
                width: 32,
                height: 32,
                child: CircularProgressIndicator(
                  backgroundColor: Color(0xFF01d277),
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                  strokeWidth: 2.0,
                )),
          ),
        )
      ],
    );
  }

  static getImgState(String msg, String path) {
    return Container(
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            Image(image: ExactAssetImage(path), width: 177, height: 128),
            SizedBox(height: 10.0),
            Text(msg, style: TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold))
          ]),
        ));
  }
}
