<p align="center">
  <img src="https://ndamaps.vn/logo.png" width="200" alt="NDAMaps Logo" />
</p>

# NDAMaps Dart & Flutter SDK 🎯

The official Dart SDK for the [NDAMaps REST APIs](https://ndamaps.vn).
This package is fully cross-platform and natively compatible with both pure Dart CLI projects and Flutter mobile/web apps. 

## 📦 Installation

Add to your `pubspec.yaml`:
```yaml
dependencies:
  ndamaps_sdk:
    git:
      url: https://github.com/ndamaps/sdk-dart.git
```

## 🚀 Quick Start

Initialize the `NDAMapsClient`:

```dart
import 'package:ndamaps_sdk/ndamaps_sdk.dart';

void main() async {
  // Pass in your NDAMaps API Key
  final client = NDAMapsClient(ClientOptions(apiKey: 'YOUR_API_KEY'));

  try {
    // 1. Geocoding Example
    final geoResult = await client.geocoding.forwardGoogle(
      address: 'Lotte Center',
    );
    print(geoResult['results']);

    // 2. Maps (Get Static Map Thumbnail)
    final mapUrl = client.maps.styleUrl(styleId: 'day-v1');
    print('Render Tiles via: $mapUrl');

  } on NDAMapsError catch (e) {
    print('Failed with API code: ${e.code}');
  } catch (e) {
    print('Fatal Error: $e');
  }
}
```

## 🚙 Route Optimization

For logistics, calculate Travelling Salesperson routing:

```dart
final l1 = {'lat': 21.03624, 'lon': 105.77142};
final l2 = {'lat': 21.03326, 'lon': 105.78743};
final l3 = {'lat': 21.00329, 'lon': 105.81834};

final route = await client.navigation.optimizedRoute([l1, l2, l3, l1]);
final trip = route['trip'];
print('Route Legs: ${trip['legs']}');
```

## 🧠 Smart Autocomplete Linking
Just like the Google Maps SDK, `NDAMapsClient` natively stores and transmits a secure UUID v4 for the billing connection between `autocomplete()` queries and their corresponding `placeDetail()` execution automatically.

## 🛑 Error Handlers

SDK requests throw `NDAMapsError` holding logical mapping logic.
```dart
switch (error.code) {
  case 'INVALID_API_KEY': // Fix your key!
  case 'RATE_LIMIT_EXCEEDED': // Chill
  case 'PLACE_NOT_FOUND': // 404 mapping
}
```

## 📜 License
MIT License.
