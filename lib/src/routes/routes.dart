import 'package:flutter/material.dart';
import 'package:qr_reader_app/src/pages/home_page.dart';

Map<String, WidgetBuilder> getApplicationRoutes() {
  return {'home': (BuildContext context) => HomePage()};
}

