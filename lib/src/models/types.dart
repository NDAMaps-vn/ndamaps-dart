/// Typed models for NDAMaps API responses and parameters.
///
/// These models map directly to the API's JSON shapes as defined in
/// the OpenAPI specification (ndamaps-openapi.yaml).

// ── Client Options ────────────────────────────

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
    this.tilesBase = 'https://maptiles.ndamaps.vn',
    this.ndaViewBase = 'https://api-view.ndamaps.vn/v1',
    this.maxRetries = 3,
    this.baseDelayMs = 500,
  });
}

// ── Core Geometry ─────────────────────────────

/// Coordinate pair — always {lat, lng}.
class LatLng {
  final double lat;
  final double lng;

  const LatLng({required this.lat, required this.lng});

  factory LatLng.fromJson(Map<String, dynamic> json) =>
      LatLng(lat: (json['lat'] as num).toDouble(), lng: (json['lng'] as num).toDouble());

  Map<String, dynamic> toJson() => {'lat': lat, 'lng': lng};

  @override
  String toString() => '$lat,$lng';
}

/// Text + numeric value pair (route distance/duration).
class TextValue {
  final String text;
  final double value;

  const TextValue({required this.text, required this.value});

  factory TextValue.fromJson(Map<String, dynamic> json) =>
      TextValue(text: json['text'] as String, value: (json['value'] as num).toDouble());
}

// ── Autocomplete ──────────────────────────────

class StructuredFormatting {
  final String mainText;
  final String secondaryText;

  const StructuredFormatting({required this.mainText, required this.secondaryText});

  factory StructuredFormatting.fromJson(Map<String, dynamic> json) =>
      StructuredFormatting(
        mainText: json['main_text'] as String,
        secondaryText: json['secondary_text'] as String,
      );
}

class AutocompletePrediction {
  final String description;
  final String placeId;
  final StructuredFormatting? structuredFormatting;
  final List<String> types;
  final double? distanceMeters;
  final bool hasChild;

  const AutocompletePrediction({
    required this.description,
    required this.placeId,
    this.structuredFormatting,
    this.types = const [],
    this.distanceMeters,
    this.hasChild = false,
  });

  factory AutocompletePrediction.fromJson(Map<String, dynamic> json) =>
      AutocompletePrediction(
        description: json['description'] as String,
        placeId: json['place_id'] as String,
        structuredFormatting: json['structured_formatting'] != null
            ? StructuredFormatting.fromJson(json['structured_formatting'])
            : null,
        types: (json['types'] as List?)?.cast<String>() ?? [],
        distanceMeters: (json['distance_meters'] as num?)?.toDouble(),
        hasChild: json['has_child'] as bool? ?? false,
      );
}

class AutocompleteGoogleResponse {
  final List<AutocompletePrediction> predictions;
  final String status;

  const AutocompleteGoogleResponse({required this.predictions, required this.status});

  factory AutocompleteGoogleResponse.fromJson(Map<String, dynamic> json) =>
      AutocompleteGoogleResponse(
        predictions: (json['predictions'] as List)
            .map((e) => AutocompletePrediction.fromJson(e))
            .toList(),
        status: json['status'] as String,
      );
}

// ── GeoJSON FeatureCollection ─────────────────

class GeoJsonPoint {
  final String type;
  final List<double> coordinates; // [lng, lat]

  const GeoJsonPoint({this.type = 'Point', required this.coordinates});

  factory GeoJsonPoint.fromJson(Map<String, dynamic> json) =>
      GeoJsonPoint(
        type: json['type'] as String? ?? 'Point',
        coordinates: (json['coordinates'] as List).map((e) => (e as num).toDouble()).toList(),
      );
}

class PlaceProperties {
  final String? id;
  final String? name;
  final String? label;
  final String? street;
  final String? country;
  final String? region;
  final String? county;
  final String? locality;
  final List<String>? category;
  final bool hasChild;
  final double? distance;

  const PlaceProperties({
    this.id, this.name, this.label, this.street,
    this.country, this.region, this.county, this.locality,
    this.category, this.hasChild = false, this.distance,
  });

  factory PlaceProperties.fromJson(Map<String, dynamic> json) =>
      PlaceProperties(
        id: json['id'] as String?,
        name: json['name'] as String?,
        label: json['label'] as String?,
        street: json['street'] as String?,
        country: json['country'] as String?,
        region: json['region'] as String?,
        county: json['county'] as String?,
        locality: json['locality'] as String?,
        category: (json['category'] as List?)?.cast<String>(),
        hasChild: json['has_child'] as bool? ?? false,
        distance: (json['distance'] as num?)?.toDouble(),
      );
}

class Feature {
  final String type;
  final GeoJsonPoint? geometry;
  final PlaceProperties? properties;

  const Feature({this.type = 'Feature', this.geometry, this.properties});

  factory Feature.fromJson(Map<String, dynamic> json) =>
      Feature(
        type: json['type'] as String? ?? 'Feature',
        geometry: json['geometry'] != null ? GeoJsonPoint.fromJson(json['geometry']) : null,
        properties: json['properties'] != null ? PlaceProperties.fromJson(json['properties']) : null,
      );
}

class FeatureCollection {
  final String type;
  final List<Feature> features;

  const FeatureCollection({this.type = 'FeatureCollection', required this.features});

  factory FeatureCollection.fromJson(Map<String, dynamic> json) =>
      FeatureCollection(
        type: json['type'] as String? ?? 'FeatureCollection',
        features: (json['features'] as List).map((e) => Feature.fromJson(e)).toList(),
      );
}

// ── Place Detail ──────────────────────────────

class PlaceDetailResult {
  final String placeId;
  final String name;
  final String formattedAddress;
  final LatLng? location;
  final List<String>? types;

  const PlaceDetailResult({
    required this.placeId, required this.name, required this.formattedAddress,
    this.location, this.types,
  });

  factory PlaceDetailResult.fromJson(Map<String, dynamic> json) =>
      PlaceDetailResult(
        placeId: json['place_id'] as String,
        name: json['name'] as String,
        formattedAddress: json['formatted_address'] as String,
        location: json['geometry'] != null && json['geometry']['location'] != null
            ? LatLng.fromJson(json['geometry']['location'])
            : null,
        types: (json['types'] as List?)?.cast<String>(),
      );
}

class PlaceDetailGoogleResponse {
  final PlaceDetailResult result;
  final String status;

  const PlaceDetailGoogleResponse({required this.result, required this.status});

  factory PlaceDetailGoogleResponse.fromJson(Map<String, dynamic> json) =>
      PlaceDetailGoogleResponse(
        result: PlaceDetailResult.fromJson(json['result']),
        status: json['status'] as String,
      );
}

// ── Directions ────────────────────────────────

class RouteLeg {
  final TextValue distance;
  final TextValue duration;
  final String? startAddress;
  final String? endAddress;

  const RouteLeg({
    required this.distance, required this.duration,
    this.startAddress, this.endAddress,
  });

  factory RouteLeg.fromJson(Map<String, dynamic> json) =>
      RouteLeg(
        distance: TextValue.fromJson(json['distance']),
        duration: TextValue.fromJson(json['duration']),
        startAddress: json['start_address'] as String?,
        endAddress: json['end_address'] as String?,
      );
}

class Route {
  final List<RouteLeg> legs;
  final String? overviewPolyline;
  final String? summary;

  const Route({required this.legs, this.overviewPolyline, this.summary});

  factory Route.fromJson(Map<String, dynamic> json) =>
      Route(
        legs: (json['legs'] as List).map((e) => RouteLeg.fromJson(e)).toList(),
        overviewPolyline: json['overview_polyline']?['points'] as String?,
        summary: json['summary'] as String?,
      );
}

class DirectionsResponse {
  final List<Route> routes;

  const DirectionsResponse({required this.routes});

  factory DirectionsResponse.fromJson(Map<String, dynamic> json) =>
      DirectionsResponse(
        routes: (json['routes'] as List).map((e) => Route.fromJson(e)).toList(),
      );
}

// ── Forcodes ──────────────────────────────────

class ForcodeEncodeResponse {
  final String forcodes;
  final double lat;
  final double lng;
  final int resolution;
  final String adminCode;
  final String status;

  const ForcodeEncodeResponse({
    required this.forcodes, required this.lat, required this.lng,
    required this.resolution, required this.adminCode, required this.status,
  });

  factory ForcodeEncodeResponse.fromJson(Map<String, dynamic> json) =>
      ForcodeEncodeResponse(
        forcodes: json['forcodes'] as String,
        lat: (json['lat'] as num).toDouble(),
        lng: (json['lng'] as num).toDouble(),
        resolution: json['resolution'] as int,
        adminCode: json['admin_code'] as String,
        status: json['status'] as String,
      );
}

class ForcodeDecodeResponse {
  final String forcodes;
  final double? lat;
  final double? lng;
  final int? resolution;
  final String status;

  const ForcodeDecodeResponse({
    required this.forcodes, this.lat, this.lng,
    this.resolution, required this.status,
  });

  factory ForcodeDecodeResponse.fromJson(Map<String, dynamic> json) =>
      ForcodeDecodeResponse(
        forcodes: json['forcodes'] as String,
        lat: (json['lat'] as num?)?.toDouble(),
        lng: (json['lng'] as num?)?.toDouble(),
        resolution: json['resolution'] as int?,
        status: json['status'] as String,
      );
}
