class ClientOptions {
  final String apiKey;
  final String mapsApiBase;
  final String tilesBase;
  final String ndaViewBase;
  final int maxRetries;
  final int baseDelayMs;

  ClientOptions({
    required this.apiKey,
    this.mapsApiBase = 'https://mapapis.ndamaps.vn/v1',
    this.tilesBase = 'https://maptiles.openmap.vn',
    this.ndaViewBase = 'https://api-view.ndamaps.vn/v1',
    this.maxRetries = 3,
    this.baseDelayMs = 500,
  });
}
