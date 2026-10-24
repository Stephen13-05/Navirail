import 'dart:math';
import 'map_graph.dart';

class Dijkstra {
  final MapGraph graph;

  Dijkstra(this.graph);

  // Euclidean distance between two nodes
  double _distance(String a, String b) {
    final ax = graph.nodes[a]!["x"]!;
    final ay = graph.nodes[a]!["y"]!;
    final bx = graph.nodes[b]!["x"]!;
    final by = graph.nodes[b]!["y"]!;
    return sqrt(pow(ax - bx, 2) + pow(ay - by, 2));
  }

  List<String> shortestPath(String start, String goal) {
    if (!graph.nodes.containsKey(start) || !graph.nodes.containsKey(goal)) {
      return [];
    }
    final dist = <String, double>{};
    final prev = <String, String?>{};
    final unvisited = <String>{};

    // Initialize maps
    for (var node in graph.nodes.keys) {
      dist[node] = double.infinity;
      prev[node] = null;
      unvisited.add(node);
    }

    dist[start] = 0;

    while (unvisited.isNotEmpty) {
      // Pick node with smallest distance
      String current = unvisited.reduce(
        (a, b) => dist[a]! < dist[b]! ? a : b,
      );

      unvisited.remove(current);

      if (dist[current] == double.infinity) break;

      if (current == goal) break;

      if (!graph.adjacency.containsKey(current)) continue;

      // Relax all neighbors
      for (var neighbor in graph.adjacency[current]!) {
        if (!unvisited.contains(neighbor)) continue;
        double alt = dist[current]! + _distance(current, neighbor);

        if (alt < dist[neighbor]!) {
          dist[neighbor] = alt;
          prev[neighbor] = current;
        }
      }
    }

    // Build final path
    if (dist[goal] == double.infinity) return [];
    List<String> path = [];
    String? node = goal;

    while (node != null) {
      path.insert(0, node);
      node = prev[node];
    }

    return path;
  }
}
