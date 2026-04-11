import '../client.dart';

class PlacesModule {
  final NDAMapsClient client;

  PlacesModule(this.client);

  Future<Map<String, dynamic>> autocomplete({
    required String input,
    String? location,
    String? origin,
    double? radius,
    int? size,
    String? sessiontoken,
    bool? adminV2,
  }) async {
    final Map<String, String> q = {'input': input};
    if (location != null) q['location'] = location;
    if (origin != null) q['origin'] = origin;
    if (radius != null) q['radius'] = radius.toString();
    if (size != null) q['size'] = size.toString();
    if (adminV2 != null) q['admin_v2'] = adminV2.toString();

    q['sessiontoken'] = sessiontoken ?? client.sessionManager.getOrCreate();

    return client.get(client.options.mapsApiBase, '/autocomplete', q);
  }

  Future<Map<String, dynamic>> placeDetail({
    required String ids,
    String? format,
    String? sessiontoken,
    bool? adminV2,
  }) async {
    final Map<String, String> q = {'ids': ids};
    if (format != null) q['format'] = format;
    if (adminV2 != null) q['admin_v2'] = adminV2.toString();

    String? token = sessiontoken;
    if (token == null) {
      final curr = client.sessionManager.getCurrent();
      if (curr != null) {
        token = curr;
        client.sessionManager.reset();
      }
    }
    if (token != null) q['sessiontoken'] = token;

    return client.get(client.options.mapsApiBase, '/place', q);
  }
}
