import '../client.dart';

class GeocodingModule {
  final NDAMapsClient client;

  GeocodingModule(this.client);

  Future<Map<String, dynamic>> forwardGoogle({required String address, bool? adminV2}) async {
    final Map<String, String> q = {'address': address};
    if (adminV2 != null) q['admin_v2'] = adminV2.toString();
    return client.get(client.options.mapsApiBase, '/geocode/forward', q);
  }

  Future<Map<String, dynamic>> reverseGoogle({required String latlng, bool? adminV2}) async {
    final Map<String, String> q = {'latlng': latlng};
    if (adminV2 != null) q['admin_v2'] = adminV2.toString();
    return client.get(client.options.mapsApiBase, '/geocode/reverse', q);
  }
}
