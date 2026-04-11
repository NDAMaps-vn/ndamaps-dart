import 'dart:convert';
import '../client.dart';

class NavigationModule {
  final NDAMapsClient client;

  NavigationModule(this.client);

  Future<Map<String, dynamic>> directions({
    required String origin,
    required String destination,
    String? vehicle,
    bool? alternatives,
  }) async {
    final Map<String, String> q = {'origin': origin, 'destination': destination};
    if (vehicle != null) q['vehicle'] = vehicle;
    if (alternatives != null) q['alternatives'] = alternatives.toString();
    return client.get(client.options.mapsApiBase, '/direction', q);
  }

  Future<Map<String, dynamic>> distanceMatrix(List<Map<String, dynamic>> sources, List<Map<String, dynamic>> targets) async {
    final body = jsonEncode({'sources': sources, 'targets': targets});
    return client.get(client.options.mapsApiBase, '/distancematrix', {'json': body});
  }

  Future<Map<String, dynamic>> optimizedRoute(List<Map<String, dynamic>> locations, {String? costing}) async {
    final body = jsonEncode({'locations': locations, 'costing': costing ?? 'auto'});
    return client.get(client.options.mapsApiBase, '/optimized-route', {'json': body});
  }
}
