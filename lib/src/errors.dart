class NDAMapsError implements Exception {
  final String code;
  final String message;
  final int statusCode;

  NDAMapsError(this.code, this.message, this.statusCode);

  @override
  String toString() => 'NDAMapsError: $code - $message (Status: $statusCode)';
}

String mapHttpStatus(int status) {
  switch (status) {
    case 400: return 'INVALID_PARAMS';
    case 401:
    case 403: return 'INVALID_API_KEY';
    case 404: return 'PLACE_NOT_FOUND';
    case 429: return 'RATE_LIMIT_EXCEEDED';
    default: return status >= 500 ? 'NETWORK_ERROR' : 'UNKNOWN';
  }
}

String? mapResponseStatus(String status) {
  switch (status) {
    case 'OK': return null;
    case 'INVALID_FORCODES': return 'INVALID_FORCODE';
    case 'NOT_FOUND': return 'PLACE_NOT_FOUND';
    case 'ZERO_RESULTS': return 'ZERO_RESULTS';
    case 'INVALID_REQUEST': return 'INVALID_PARAMS';
    case 'REQUEST_DENIED': return 'INVALID_API_KEY';
    case 'OVER_QUERY_LIMIT': return 'RATE_LIMIT_EXCEEDED';
    default: return null;
  }
}
