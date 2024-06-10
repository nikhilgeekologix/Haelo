import 'package:flutter/material.dart';

///Creates responsive UI for different screen sizes
///for specific [Orientation]

class SizeConfig {
  //TODO: Change default parameters as per your device
  //default parameters of the design
  // static const double _defaultScreenWidth = 187.5;
  // static const double _defaultScreenHeight = 406;

  //Designer new designs Figma
  static const double _defaultScreenWidth = 375.0;
  static const double _defaultScreenHeight = 667.0;

  //parameters required for calculating SizeConfig
  final Size screenSize;
  final Orientation orientation;

  //Scale Factor
  static double _widthMultiplier = 1;
  static double _heightMultiplier = 1;

  //actual dimensions of the screen
  static double _actualScreenWidth = 0;
  static double _actualScreenHeight = 0;

  //multiplying factors
  static double _widthMultiplyingFactor = 1;
  static double _heightMultiplyingFactor = 1;

  //orientation of the screen
  static Orientation _orientation = Orientation.portrait;

  //default constructor
  SizeConfig.init({required this.screenSize, required this.orientation}) {
    //so that we can access orientation in getInfo()
    _orientation = orientation;

    //initialising actual screen dimensions
    _actualScreenWidth = screenSize.shortestSide;
    _actualScreenHeight = screenSize.longestSide;

    if (orientation == Orientation.portrait) {
      //calculating multiplication factors
      _widthMultiplyingFactor = _actualScreenWidth / _defaultScreenWidth;
      _heightMultiplyingFactor = _actualScreenHeight / _defaultScreenHeight;

      //assigning scale Factors
      _widthMultiplier = _actualScreenWidth / 100;
      _heightMultiplier = _actualScreenHeight / 100;
    }

    //interchanging height and width for landscape
    else if (orientation == Orientation.landscape) {
      _heightMultiplyingFactor = _actualScreenWidth / _defaultScreenWidth;
      _widthMultiplyingFactor = _actualScreenHeight / _defaultScreenHeight;

      //assigning scale Factors
      _widthMultiplier = _actualScreenHeight / 100;
      _heightMultiplier = _actualScreenWidth / 100;
    }
  }

  ///Returns width of device
  ///
  ///in fraction as [double]
  ///UseCase
  ///[width = SizeConfig.widthMultiplier * 50]
  ///
  ///It assigns 50% of your screen [width]
  static double get widthMultiplier => _widthMultiplier;

  ///Returns width of device
  ///
  ///in fraction as [double]
  ///UseCase
  ///[height = SizeConfig.heightMultiplier * 50]
  ///
  ///It assigns 50% of your screen [height]
  static double get heightMultiplier => _heightMultiplier;

  ///Pass the width in pixels
  ///
  ///Returns responsive width as [double]
  static double setWidth(double width) => width * _widthMultiplyingFactor;

  ///Pass the height in pixels
  ///
  ///Returns responsive height as [double]
  static double setHeight(double height) => height * _heightMultiplyingFactor;

  ///Pass the font size in pixels
  ///
  ///Returns responsive size as [double]
  static double setSp(double size) {
    if (_orientation == Orientation.landscape) {
      return setHeight(size);
    }
    return setWidth(size);
  }

  ///Pass the Image size in pixels
  ///
  ///Returns responsive size as [double]
  static double setImageSize(double size) {
    if (_orientation == Orientation.landscape) {
      return setHeight(size);
    }
    return setWidth(size);
  }

  ///Get information about current screen layout
  ///
  ///Returns a Multi-line [String]
  static String getInfo() {
    return '''\n
    orientation: $_orientation
    default screen width: $_defaultScreenWidth
    default screen height: $_defaultScreenHeight
    actual screen width: $_actualScreenWidth
    actual screen height: $_actualScreenHeight
    width multiplying factor: $_widthMultiplyingFactor
    height multiplying factor: $_heightMultiplyingFactor
    ''';
  }
}
