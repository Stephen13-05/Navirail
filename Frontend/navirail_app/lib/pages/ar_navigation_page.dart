import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/map_graph.dart';
import '../services/dijkstra.dart';

class ArNavigationPage extends StatefulWidget {
  const ArNavigationPage({super.key});

  @override
  State<ArNavigationPage> createState() => _ArNavigationPageState();
}

class _ArNavigationPageState extends State<ArNavigationPage> {
  static const _platform = MethodChannel('ar_nav_channel');

  late final MapGraph _graph;
  late final Dijkstra _dijkstra;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initGraph();
  }

  Future<void> _initGraph() async {
    try {
      _graph = MapGraph();
      await _graph.load();
      _dijkstra = Dijkstra(_graph);
      setState(() {
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _error = 'Failed to load map: $e';
      });
    }
  }

  Future<void> _startArNavigation() async {
    const startNodeId = 'entrance_1';
    const endNodeId = 'platform_4';

    final path = _dijkstra.shortestPath(startNodeId, endNodeId);
    if (path.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No path found')),
      );
      return;
    }

    try {
      await _platform.invokeMethod('start_ar_navigation', {
        'path': path,
      });
    } on PlatformException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to start AR: ${e.message}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('AR Navigation')),
        body: Center(child: Text(_error!)),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('AR Navigation')),
      body: Center(
        child: ElevatedButton.icon(
          onPressed: _startArNavigation,
          icon: const Icon(Icons.vrpano),
          label: const Text('Start AR Navigation'),
        ),
      ),
    );
  }
}
