import 'dart:convert';
import 'package:http/http.dart' as http;
import 'models/types.dart';
import 'errors.dart';
import 'session_manager.dart';
import 'modules/places.dart';
import 'modules/geocoding.dart';
import 'modules/navigation.dart';
import 'modules/maps.dart';
import 'modules/ndaview.dart';
import 'modules/forcodes.dart';

class NDAMapsClient {
  final ClientOptions options;
  final SessionManager sessionManager = SessionManager();
  
  late final PlacesModule places;
  late final GeocodingModule geocoding;
  late final NavigationModule navigation;
  late final MapsModule maps;
  late final NDAViewModule ndaview;
  late final ForcodesModule forcodes;

  NDAMapsClient(this.options) {
    places = PlacesModule(this);
    geocoding = GeocodingModule(this);
    navigation = NavigationModule(this);
    maps = MapsModule(this);
    ndaview = NDAViewModule(this);
    forcodes = ForcodesModule(this);
  }

  Future<Map<String, dynamic>> get(String base, String path, Map<String, String> query) async {
    return _doReq('GET', base, path, query, null);
  }

  Future<Map<String, dynamic>> post(String base, String path, Map<String, String> query, String? body) async {
    return _doReq('POST', base, path, query, body);
  }

  Future<Map<String, dynamic>> _doReq(String method, String base, String path, Map<String, String> query, String? body) async {
    final Map<String, String> q = Map.from(query);
    q['apikey'] = options.apiKey;

    final uri = Uri.parse('$base$path').replace(queryParameters: q);

    Exception? lastErr;

    for (var attempt = 0; attempt <= options.maxRetries; attempt++) {
      if (attempt > 0) {
        await Future.delayed(Duration(milliseconds: options.baseDelayMs * (1 << (attempt - 1))));
      }

      try {
        http.Response resp;
        if (method == 'POST') {
          resp = await http.post(uri, headers: {'Content-Type': 'application/json'}, body: body);
        } else {
          resp = await http.get(uri);
        }

        final status = resp.statusCode;
        final bodyStr = resp.body;

        if (status >= 400) {
          if (status == 429 || status >= 500) {
            lastErr = NDAMapsError(mapHttpStatus(status), 'HTTP $status', status);
            continue;
          }
          throw NDAMapsError(mapHttpStatus(status), bodyStr, status);
        }

        final Map<String, dynamic> jsonObj = jsonDecode(bodyStr);
        if (jsonObj.containsKey('status')) {
          final errCode = mapResponseStatus(jsonObj['status'].toString());
          if (errCode != null) throw NDAMapsError(errCode, jsonObj['status'], status);
        }
        return jsonObj;
      } catch (e) {
        if (e is NDAMapsError) rethrow;
        lastErr = Exception('Network error: $e');
      }
    }

    throw NDAMapsError('RETRIES_EXHAUSTED', 'Max retries reached: $lastErr', 0);
  }
}
