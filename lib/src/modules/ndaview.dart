import '../client.dart';

class NDAViewModule {
  final NDAMapsClient client;

  NDAViewModule(this.client);

  Future<Map<String, dynamic>> search({String? bbox, int? limit}) async {
    final Map<String, String> q = {};
    if (bbox != null) q['bbox'] = bbox;
    if (limit != null) q['limit'] = limit.toString();
    return client.get(client.options.ndaViewBase, '/search', q);
  }
}
