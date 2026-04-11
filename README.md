# NDAMaps Dart SDK

Official Dart/Flutter SDK for NDAMaps REST APIs.

## Installation

Add to your `pubspec.yaml`:
```yaml
dependencies:
  ndamaps_sdk:
    git:
      url: https://github.com/ndamaps/sdk-dart.git
```

## Usage

```dart
import 'package:ndamaps_sdk/ndamaps_sdk.dart';

void main() async {
  final client = NDAMapsClient(ClientOptions(apiKey: 'YOUR_API_KEY'));
  final res = await client.places.autocomplete(input: 'Hồ Hoàn Kiếm');
  print(res);
}
```
