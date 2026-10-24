import '../services/station_selection.dart';
// Web-only adapter keeps the existing native Flutter screens available.
// ignore: deprecated_member_use, avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:ui_web' as ui_web;
import 'package:flutter/widgets.dart';
bool _registered = false;
Widget? buildStationExplorer() {
  if (!_registered) {
    ui_web.platformViewRegistry.registerViewFactory('navirail-explorer', (int id) {
      final frame = html.IFrameElement()
        ..src = Uri(path: '/explorer/', queryParameters: {'embedded': '1', 'station': StationSelection.code}).toString()
        ..title = 'NaviRail station explorer'
        ..style.border = '0'
        ..style.width = '100%'
        ..style.height = '100%';
      return frame;
    });
    _registered = true;
  }
  return const HtmlElementView(viewType: 'navirail-explorer');
}


