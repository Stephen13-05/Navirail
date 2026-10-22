import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class MapGraph {
  late Map<String, Map<String, double>> nodes;
  late List<List<String>> edges;
  late Map<String, List<String>> adjacency;

  Future<void> load() async {
    final data = await rootBundle.loadString("assets/map/map.json");
    final jsonData = jsonDecode(data);

    // Load nodes, supporting both {"x","y"} and {"x_m","y_m"} formats
    nodes = (jsonData["nodes"] as Map).map(
      (key, value) {
        final v = value as Map;
        double x;
        double y;

        if (v.containsKey("x") && v.containsKey("y")) {
          x = (v["x"] as num).toDouble();
          y = (v["y"] as num).toDouble();
        } else if (v.containsKey("x_m") && v.containsKey("y_m")) {
          x = (v["x_m"] as num).toDouble();
          y = (v["y_m"] as num).toDouble();
        } else {
          throw FormatException('Node $key missing x/y or x_m/y_m');
        }

        return MapEntry(key, {"x": x, "y": y});
      },
    );

    // Load edges
    edges = List<List<String>>.from(
      jsonData["edges"].map((e) => List<String>.from(e)),
    );

    // Build adjacency list
    adjacency = {};
    for (var e in edges) {
      adjacency.putIfAbsent(e[0], () => []).add(e[1]);
      adjacency.putIfAbsent(e[1], () => []).add(e[0]);
    }
  }
}
