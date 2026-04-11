import 'dart:io';
import 'package:test/test.dart';
import 'package:ndamaps_sdk/ndamaps_sdk.dart';

void main() {
  final apiKey = Platform.environment['NDAMAPS_API_KEY'];
  if (apiKey == null) {
    print('Skipping tests: NDAMAPS_API_KEY not found');
    return;
  }

  final client = NDAMapsClient(ClientOptions(apiKey: apiKey));

  test('Test Autocomplete', () async {
    final res = await client.places.autocomplete(input: 'Hồ Hoàn Kiếm');
    expect(res['status'], equals('OK'));
    expect(res.containsKey('predictions'), isTrue);
  });

  test('Test Optimized Route', () async {
    final l1 = {'lat': 21.03624, 'lon': 105.77142};
    final l2 = {'lat': 21.03326, 'lon': 105.78743};
    final l3 = {'lat': 21.00329, 'lon': 105.81834};

    final res = await client.navigation.optimizedRoute([l1, l2, l3, l1]);
    expect(res.containsKey('trip'), isTrue);
    final trip = res['trip'] as Map<String, dynamic>;
    final locations = trip['locations'] as List;
    expect(locations.length, equals(4));
  });
}
