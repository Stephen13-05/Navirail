import 'package:flutter_test/flutter_test.dart';
import 'package:navirail_app/services/dijkstra.dart';
import 'package:navirail_app/services/map_graph.dart';

void main() {
  late MapGraph graph;
  setUp(() {
    graph = MapGraph()
      ..nodes = {
        'entrance': {'x': 0, 'y': 0},
        'hall': {'x': 3, 'y': 0},
        'platform': {'x': 3, 'y': 4},
        'isolated': {'x': 10, 'y': 10},
      }
      ..adjacency = {
        'entrance': ['hall'],
        'hall': ['entrance', 'platform'],
        'platform': ['hall'],
      };
  });
  test('follows connected pedestrian nodes', () {
    expect(Dijkstra(graph).shortestPath('entrance', 'platform'),
        ['entrance', 'hall', 'platform']);
  });
  test('unreachable destination has no route', () {
    expect(Dijkstra(graph).shortestPath('entrance', 'isolated'), isEmpty);
  });
  test('unknown endpoints have no route', () {
    expect(Dijkstra(graph).shortestPath('missing', 'platform'), isEmpty);
    expect(Dijkstra(graph).shortestPath('entrance', 'missing'), isEmpty);
  });
  test('starting at destination produces a stationary route', () {
    expect(Dijkstra(graph).shortestPath('entrance', 'entrance'), ['entrance']);
  });
  test('closed connection cannot be traversed', () {
    graph.adjacency['hall']!.remove('platform');
    graph.adjacency['platform']!.remove('hall');
    expect(Dijkstra(graph).shortestPath('entrance', 'platform'), isEmpty);
  });
}
