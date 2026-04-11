import '../client.dart';

class MapsModule {
  final NDAMapsClient client;

  MapsModule(this.client);

  String styleUrl({String styleId = 'day-v1'}) {
    return '${client.options.tilesBase}/styles/$styleId/style.json?apikey=${client.options.apiKey}';
  }
}
