import '../client.dart';

class ForcodesModule {
  final NDAMapsClient client;

  ForcodesModule(this.client);

  Future<Map<String, dynamic>> encode({required double lat, required double lng, int? resolution}) async {
    final Map<String, String> q = {'lat': lat.toString(), 'lng': lng.toString()};
    if (resolution != null) q['resolution'] = resolution.toString();
    return client.post(client.options.mapsApiBase, '/forcodes/encode', q, null);
  }

  Future<Map<String, dynamic>> decode({required String forcodes}) async {
    return client.post(client.options.mapsApiBase, '/forcodes/decode', {'forcodes': forcodes}, null);
  }
}
