<p align="center">
  <img src="https://ndamaps.vn/logo.png" width="200" alt="NDAMaps Logo" />
</p>

# NDAMaps Dart & Flutter SDK

Official **Dart** package for **NDAMaps** — Vietnam's national digital map platform API.

Works in **Flutter** (mobile/web) and **pure Dart** (CLI, servers).

## Features

- **Places** — Autocomplete and place detail with **automatic session tokens**
- **Geocoding** — Forward/reverse helpers (e.g. `forwardGoogle`)
- **Navigation** — Directions, matrix, **optimized route**
- **Maps** — MapLibre **style** URLs and static map helpers where exposed by the client
- **NDAView**, **Forcodes**, and unified **`NDAMapsError`** handling

## Requirements

- Dart **3.0+** (`sdk: '>=3.0.0 <4.0.0'`)

## Install

In `pubspec.yaml`:

```yaml
dependencies:
  ndamaps_sdk:
    git:
      url: https://github.com/NDAMaps-vn/ndamaps-dart.git
```

Then run `dart pub get` or `flutter pub get`.

## Quick start

```dart
import 'package:ndamaps_sdk/ndamaps_sdk.dart';

Future<void> main() async {
  final client = NDAMapsClient(ClientOptions(apiKey: 'YOUR_API_KEY'));

  try {
    final geo = await client.geocoding.forwardGoogle(address: 'Lotte Center');
    print(geo['results']);

    final styleUrl = client.maps.styleUrl(styleId: 'day-v1');
    print(styleUrl);
  } on NDAMapsError catch (e) {
    print('API error: ${e.code}');
  }
}
```

## Session tokens (billing)

The client keeps a **UUID v4** session between `autocomplete` and `placeDetail` when you use the high-level flow, similar to common maps SDKs, so those calls can group for billing.

## Optimized route

```dart
final l1 = {'lat': 21.03624, 'lon': 105.77142};
final l2 = {'lat': 21.03326, 'lon': 105.78743};
final l3 = {'lat': 21.00329, 'lon': 105.81834};

final route = await client.navigation.optimizedRoute([l1, l2, l3, l1]);
final trip = route['trip'];
print(trip?['legs']);
```

## Error handling

```dart
on NDAMapsError catch (error) {
  switch (error.code) {
    case 'INVALID_API_KEY':
    case 'RATE_LIMIT_EXCEEDED':
    case 'PLACE_NOT_FOUND':
      break;
    default:
      break;
  }
}
```

## Links

- [NDAMaps documentation](https://docs.ndamaps.vn)
- [NDAMaps platform](https://ndamaps.vn)

## License

MIT
