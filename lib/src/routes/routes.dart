import 'package:flutter/material.dart';
import 'package:qr_reader_app/src/pages/home_page.dart';
import 'package:qr_reader_app/src/pages/show_map_page.dart';

Map<String, WidgetBuilder> getApplicationRoutes() {
  return {
    'home': (BuildContext context) => HomePage(),
    'show_map': (BuildContext context) => ShowMapPage()
  };
}

