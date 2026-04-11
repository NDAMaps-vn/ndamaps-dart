import 'dart:io';
import 'package:ndamaps_sdk/ndamaps_sdk.dart';

void main() async {
  final apiKey = Platform.environment['NDAMAPS_API_KEY'];
  if (apiKey == null) {
    print('Please set NDAMAPS_API_KEY environment variable');
    exit(1);
  }

  final client = NDAMapsClient(ClientOptions(apiKey: apiKey));

  print('--- 1. Forward Geocoding ---');
  try {
    final geoRes = await client.geocoding.forwardGoogle(address: 'Hồ Hoàn Kiếm, Hà Nội');
    if (geoRes['results'] != null && geoRes['results'].isNotEmpty) {
      print('Result: ${geoRes['results'][0]['geometry']['location']}');
    }

    print('\n--- 2. Optimized Route (Travelling Salesperson) ---');
    final l1 = {'lat': 21.03624, 'lon': 105.77142};
    final l2 = {'lat': 21.03326, 'lon': 105.78743};
    final l3 = {'lat': 21.00329, 'lon': 105.81834};

    final routeRes = await client.navigation.optimizedRoute([l1, l2, l3, l1]);
    final trip = routeRes['trip'];
    if (trip != null && trip['summary'] != null) {
      print('Total Distance: ${trip['summary']['length']} meters');
      print('Total ETA: ${trip['summary']['time']} seconds');
    }
  } catch (e) {
    print('Error: $e');
  }
}
